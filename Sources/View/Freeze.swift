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
    ///     - data: Modify views before being updated.
    ///     - type: The type of the app storage.
    /// - Returns: The view storage.
    func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        content.storage(data: data, type: type)
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The type of the app storage.
    func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        guard !freeze else {
            return
        }
        content.updateStorage(storage, data: data, updateProperties: updateProperties, type: type)
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
