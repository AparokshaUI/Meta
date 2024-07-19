//
//  AppearObserver.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// Run a custom code accessing the view's storage when initializing the view.
struct AppearObserver: ConvenienceWidget {

    /// The custom code to edit the widget.
    var modify: (ViewStorage) -> Void
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
        let storage = content.storage(modifiers: modifiers, type: type)
        modify(storage)
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
        content.updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

}

extension AnyView {

    /// Run a function on the widget when it appears for the first time.
    /// - Parameter closure: The function.
    /// - Returns: A view.
    public func inspectOnAppear(_ closure: @escaping (ViewStorage) -> Void) -> AnyView {
        AppearObserver(modify: closure, content: self)
    }

    /// Run a function when the view appears for the first time.
    /// - Parameter closure: The function.
    /// - Returns: A view.
    public func onAppear(_ closure: @escaping () -> Void) -> AnyView {
        inspectOnAppear { _ in closure() }
    }

}
