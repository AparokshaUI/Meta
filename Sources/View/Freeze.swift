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

    /// The debug tree parameters.
    var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [
            ("freeze", value: freeze)
        ]
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
        .init(nil, content: [.mainContent: [content.storage(modifiers: modifiers, type: type)]])
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
        guard !freeze, let storage = storage.content[.mainContent]?.first else {
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
