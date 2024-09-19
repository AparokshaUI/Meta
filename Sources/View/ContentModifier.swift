//
//  ContentModifier.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// A widget which replaces views of a specific type in its content.
struct ContentModifier<Content>: ConvenienceWidget where Content: AnyView {

    /// The wrapped view.
    var content: AnyView
    /// The closure for the modification.
    var modify: @Sendable (Content) -> AnyView

    /// The view storage.
    /// - Parameters:
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) async -> ViewStorage where Data: ViewRenderData {
        await content.storage(data: data.modify { $0.modifiers += [modifyView] }, type: type)
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
        await content
            .updateStorage(
                storage,
                data: data.modify { $0.modifiers += [modifyView] },
                updateProperties: updateProperties,
                type: type
            )
    }

    /// Apply the modifier to a view.
    /// - Parameter view: The view.
    func modifyView(_ view: AnyView) -> AnyView {
        if let view = view as? Content {
            return modify(view).stopModifiers()
        } else {
            return view
        }
    }

}

/// Extend any view.
extension AnyView {

    /// Replace every occurrence of a certain view type in the content.
    /// - Parameters:
    ///     - type: The view type.
    ///     - modify: Modify the view.
    /// - Returns: A view.
    public func modifyContent<Content>(
        _ type: Content.Type,
        modify: @Sendable @escaping (Content) -> AnyView
    ) -> AnyView where Content: AnyView {
        ContentModifier(content: self, modify: modify)
    }

}
