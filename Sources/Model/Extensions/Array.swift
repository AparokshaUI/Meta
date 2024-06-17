//
//  Array.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

import Foundation

extension Array: AnyView where Element == AnyView {

    /// The array's view body is the array itself.
    public var viewContent: Body { self }

    /// Get the debug tree for an array of views.
    /// - Parameter parameters: Whether the widget parameters should be visible in the tree.
    /// - Returns: The tree.
    public func getBodyDebugTree<WidgetType>(parameters: Bool, type: WidgetType.Type) -> String {
        var description = ""
        for view in self where view.renderable(type: type) {
            let viewDescription: String
            if let widget = view as? Widget {
                viewDescription = widget.getViewDescription(parameters: parameters, type: type)
            } else {
                viewDescription = view.getDebugTree(parameters: parameters, type: type)
            }
            description += viewDescription + "\n"
        }
        if !description.isEmpty {
            description.removeLast()
        }
        return description
    }

    /// Get a widget from a collection of views.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: A widget.
    public func widget(modifiers: [(AnyView) -> AnyView]) -> Widget {
        if count == 1, let widget = self[safe: 0]?.widget(modifiers: modifiers) {
            return widget
        } else {
            var modified = self
            for (index, view) in modified.enumerated() {
                for modifier in modifiers {
                    modified[safe: index] = modifier(view)
                }
            }
            return Wrapper { modified }
        }
    }

    /// Update a collection of views with a collection of view storages.
    /// - Parameters:
    ///     - storage: The collection of view storages.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    ///     - type: The type of the widgets.
    public func update<WidgetType>(_ storage: [ViewStorage], modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: WidgetType.Type) {
        for (index, element) in enumerated() where element.renderable(type: type) {
            if let storage = storage[safe: index] {
                element
                    .widget(modifiers: modifiers)
                    .updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
            }
        }
    }

}

extension Array where Element == String {

    /// Get the C version of the array.
    var cArray: UnsafePointer<UnsafePointer<CChar>?>? {
        let cStrings = self.map { $0.utf8CString }
        let cStringPointers = cStrings.map { $0.withUnsafeBufferPointer { $0.baseAddress } }
        let optionalCStringPointers = cStringPointers + [nil]
        var optionalCStringPointersCopy = optionalCStringPointers
        optionalCStringPointersCopy.withUnsafeMutableBufferPointer { bufferPointer in
            bufferPointer.baseAddress?.advanced(by: cStrings.count).pointee = nil
        }
        let flatArray = optionalCStringPointersCopy.compactMap { $0 }
        let pointer = UnsafeMutablePointer<UnsafePointer<CChar>?>.allocate(capacity: flatArray.count + 1)
        for (index, element) in flatArray.enumerated() {
            pointer.advanced(by: index).pointee = element
        }
        pointer.advanced(by: flatArray.count).pointee = nil
        return UnsafePointer(pointer)
    }

}

extension Array {

    /// Accesses the element at the specified position safely.
    /// - Parameters:
    ///   - index: The position of the element to access.
    ///
    ///   Access and set elements the safe way:
    ///   ```swift
    ///   var array = ["Hello", "World"]
    ///   print(array[safe: 2] ?? "Out of range")
    ///   ```
    public subscript(safe index: Int?) -> Element? {
        get {
            if let index, indices.contains(index) {
                return self[index]
            }
            return nil
        }
        set {
            if let index, let value = newValue, indices.contains(index) {
                self[index] = value
            }
        }
    }

}

extension Array where Element: Identifiable {

    /// Accesses the element with a certain id safely.
    /// - Parameters:
    ///   - id: The child's id.
    ///
    ///   Access and set elements the safe way:
    ///   ```swift
    ///   var array = ["Hello", "World"]
    ///   print(array[safe: 2] ?? "Out of range")
    ///   ```
    public subscript(id id: Element.ID) -> Element? {
        self[safe: firstIndex { $0.id == id }]
    }

}
