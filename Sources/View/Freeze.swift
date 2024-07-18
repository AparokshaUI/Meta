//
//  Freeze.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// State whether to update the child views or not.
struct Freeze: ConvenienceWidget {

    /// Whether not to update the child view.
    var freeze: Bool
    /// The wrapped view.
    var content: AnyView

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the app storage.
    /// - Returns: The view storage.
    func container<Data>(
        modifiers: [(any AnyView) -> any AnyView],
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        content.storage(modifiers: modifiers, type: type)
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - modifiers: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The type of the app storage.
    func update<Data>(
        _ storage: ViewStorage,
        modifiers: [(any AnyView) -> any AnyView],
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        guard !freeze else {
            return
        }
        content.updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

}

extension AnyView {

    /// Prevent a view from being updated.
    /// - Parameter freeze: Whether to freeze the view.
    /// - Returns: A view.
    public func freeze(_ freeze: Bool = true) -> AnyView {
        Freeze(freeze: freeze, content: self)
    }

}
