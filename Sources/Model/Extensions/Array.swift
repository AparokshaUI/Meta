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
    public func getBodyDebugTree<WidgetType>(
        parameters: Bool,
        type: WidgetType.Type,
        modifiers: [(AnyView) -> AnyView] = []
    ) -> String {
        let oldValue = StateManager.saveState
        StateManager.saveState = false
        var description = ""
        for view in self where view.renderable(type: type, modifiers: modifiers) {
            description += view.getDebugTree(parameters: parameters, type: type, modifiers: modifiers) + "\n"
        }
        if !description.isEmpty {
            description.removeLast()
        }
        StateManager.saveState = oldValue
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
    public func update<WidgetType>(
        _ storage: [ViewStorage],
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: WidgetType.Type
    ) {
        for (index, element) in filter({ $0.renderable(type: type, modifiers: modifiers) }).enumerated() {
            if let storage = storage[safe: index] {
                element
                    .widget(modifiers: modifiers)
                    .updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
            }
        }
    }

    /// Get the view storages of a collection of views.
    /// - Parameters:
    ///     - modifiers: Modify views before generating the storages.
    ///     - type: The type of the widgets.
    public func storages<WidgetType>(
        modifiers: [(AnyView) -> AnyView],
        type: WidgetType.Type
    ) -> [ViewStorage] {
        compactMap { view in
            view.renderable(type: type, modifiers: modifiers) ? view.storage(modifiers: modifiers, type: type) : nil
        }
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
