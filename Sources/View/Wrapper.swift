//
//  Wrapper.swift
//  Meta
//
//  Created by david-swift on 27.05.24.
//

/// Wrap a body into a single widget.
public struct Wrapper: ConvenienceWidget {

    /// The content.
    var content: Body

    /// Initialize a `Wrapper`.
    /// - Parameter content: The view content.
    public init(@ViewBuilder content: @escaping () -> Body) {
        self.content = content()
    }

    /// Update a view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    ///     - type: The widget types.
    public func update<WidgetType>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: WidgetType.Type
    ) {
        guard let storages = storage.content[.mainContent] else {
            return
        }
        content.update(storages, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

    /// Get a view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the widgets.
    /// - Returns: The view storage.
    public func container<WidgetType>(modifiers: [(AnyView) -> AnyView], type: WidgetType.Type) -> ViewStorage {
        .init(nil, content: [.mainContent: content.storages(modifiers: modifiers, type: type)])
    }

}
