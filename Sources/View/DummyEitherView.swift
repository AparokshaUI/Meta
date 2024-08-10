//
//  DummyEitherView.swift
//  Meta
//
//  Created by david-swift on 06.08.24.
//

/// A dummy either view. This will be replaced by the platform-specific either view.
struct DummyEitherView: Widget {

    /// Whether to present the first view.
    var condition: Bool
    /// The first view.
    var view1: Body?
    /// The second view.
    var view2: Body?

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the app storage.
    /// - Returns: The view storage.
    func container<Data>(
        modifiers: [(any AnyView) -> any AnyView],
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let content = type.EitherViewType(condition) { view1 ?? [] } else: { view2 ?? [] }
        let storage = content.storage(modifiers: modifiers, type: type)
        return storage
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
        let content = type.EitherViewType(condition) { view1 ?? [] } else: { view2 ?? [] }
        content.updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

}
