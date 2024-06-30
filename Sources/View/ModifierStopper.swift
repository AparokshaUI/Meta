//
//  ModifierStopper.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// Remove all of the content modifiers for the wrapped views.
struct ModifierStopper: ConvenienceWidget {

    /// The wrapped view.
    var content: AnyView

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the widgets.
    func container<WidgetType>(modifiers: [(any AnyView) -> any AnyView], type: WidgetType.Type) -> ViewStorage {
        .init(nil, content: [.mainContent: [content.storage(modifiers: [], type: type)]])
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
        content.updateStorage(storage, modifiers: [], updateProperties: updateProperties, type: type)
    }

}

extension AnyView {

    /// Remove all of the content modifiers for the wrapped views.
    /// - Returns: A view.
    public func stopModifiers() -> AnyView {
        ModifierStopper(content: self)
    }

}
