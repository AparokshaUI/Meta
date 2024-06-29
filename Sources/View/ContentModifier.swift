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
    var modify: (Content) -> AnyView

    /// The debug tree parameters.
    var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [("modify", value: "(Content) -> AnyView")]
    }

    /// The debug tree's content.
    var debugTreeContent: [(String, body: Body)] {
        [("content", body: [content])]
    }

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the widgets.
    func container<WidgetType>(modifiers: [(any AnyView) -> any AnyView], type: WidgetType.Type) -> ViewStorage {
        .init(nil, content: [.mainContent: [content.storage(modifiers: modifiers + [modifyView], type: type)]])
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - modifiers: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The type of the widgets.
    func update<WidgetType>(
        _ storage: ViewStorage,
        modifiers: [(any AnyView) -> any AnyView],
        updateProperties: Bool,
        type: WidgetType.Type
    ) {
        guard let storage = storage.content[.mainContent]?.first else {
            return
        }
        content
            .updateStorage(storage, modifiers: modifiers + [modifyView], updateProperties: updateProperties, type: type)
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

extension AnyView {

    /// Replace every occurrence of a certain view type in the content.
    /// - Parameters:
    ///     - type: The view type.
    ///     - modify: Modify the view.
    /// - Returns: A view.
    public func modifyContent<Content>(
        _ type: Content.Type,
        modify: @escaping (Content) -> AnyView
    ) -> AnyView where Content: AnyView {
        ContentModifier(content: self, modify: modify)
    }

}
