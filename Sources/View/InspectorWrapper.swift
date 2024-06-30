//
//  InspectorWrapper.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// Run a custom code accessing the view's storage when initializing and updating the view.
struct InspectorWrapper: ConvenienceWidget {

    /// The custom code to edit the widget.
    var modify: (ViewStorage) -> Void
    /// The wrapped view.
    var content: AnyView

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the widgets.
    func container<WidgetType>(modifiers: [(any AnyView) -> any AnyView], type: WidgetType.Type) -> ViewStorage {
        let storage = content.storage(modifiers: modifiers, type: type)
        modify(storage)
        return .init(nil, content: [.mainContent: [storage]])
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
        content.updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
        modify(storage)
    }

}

extension AnyView {

    /// Run a custom code accessing the view's storage when initializing and updating the view.
    /// - Parameter modify: Modify the storage.
    /// - Returns: A view.
    public func inspect(_ modify: @escaping (ViewStorage) -> Void) -> AnyView {
        InspectorWrapper(modify: modify, content: self)
    }

    /// Run a function when the view gets updated.
    /// - Parameter onUpdate: The function.
    /// - Returns: A view.
    public func onUpdate(_ onUpdate: @escaping () -> Void) -> AnyView {
        inspect { _ in onUpdate() }
    }

}
