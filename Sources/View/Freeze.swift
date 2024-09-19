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
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) async -> ViewStorage where Data: ViewRenderData {
        await content.storage(data: data, type: type)
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) async where Data: ViewRenderData {
        guard !freeze else {
            return
        }
        await content.updateStorage(storage, data: data, updateProperties: updateProperties, type: type)
    }

}

/// Extend any view.
extension AnyView {

    /// Prevent a view from being updated.
    /// - Parameter freeze: Whether to freeze the view.
    /// - Returns: A view.
    public func freeze(_ freeze: Bool = true) -> AnyView {
        Freeze(freeze: freeze, content: self)
    }

}
