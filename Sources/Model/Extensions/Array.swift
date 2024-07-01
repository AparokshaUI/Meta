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

    /// Get a widget from a collection of views.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The app storage type.
    /// - Returns: A widget.
    public func widget<Storage>(
        modifiers: [(AnyView) -> AnyView],
        type: Storage.Type
    ) -> Widget where Storage: AppStorage {
        if count == 1, let widget = self[safe: 0]?.widget(modifiers: modifiers, type: type) {
            return widget
        } else {
            var modified = self
            for (index, view) in modified.enumerated() {
                for modifier in modifiers {
                    modified[safe: index] = modifier(view)
                }
            }
            return Storage.WrapperType { modified }
        }
    }

    /// Update a collection of views with a collection of view storages.
    /// - Parameters:
    ///     - storage: The collection of view storages.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    ///     - type: The type of the app storage.
    public func update<Storage>(
        _ storage: [ViewStorage],
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: Storage.Type
    ) where Storage: AppStorage {
        for (index, element) in filter({ $0.renderable(type: type, modifiers: modifiers) }).enumerated() {
            if let storage = storage[safe: index] {
                element
                    .widget(modifiers: modifiers, type: type)
                    .updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
            }
        }
    }

    /// Get the view storages of a collection of views.
    /// - Parameters:
    ///     - modifiers: Modify views before generating the storages.
    ///     - type: The type of the app storage.
    /// - Returns: The storages.
    public func storages<Storage>(
        modifiers: [(AnyView) -> AnyView],
        type: Storage.Type
    ) -> [ViewStorage] where Storage: AppStorage {
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
