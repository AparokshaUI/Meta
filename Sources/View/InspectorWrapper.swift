//
//  InspectorWrapper.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// Run a custom code accessing the view's storage when initializing and updating the view.
struct InspectorWrapper: ConvenienceWidget {

    /// The custom code to edit the widget.
    var modify: (ViewStorage, Bool) -> Void
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
        let storage = content.storage(data: data, type: type)
        modify(storage, true)
        return storage
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
        content.updateStorage(storage, data: data, updateProperties: updateProperties, type: type)
        modify(storage, updateProperties)
    }

}

extension AnyView {

    /// Run a custom code accessing the view's storage when initializing and updating the view.
    /// - Parameter modify: Modify the storage. The boolean indicates whether state in parent views changed.
    /// - Returns: A view.
    public func inspect(_ modify: @escaping (ViewStorage, Bool) -> Void) -> AnyView {
        InspectorWrapper(modify: modify, content: self)
    }

    /// Run a function when the view gets updated.
    /// - Parameter onUpdate: The function.
    /// - Returns: A view.
    public func onUpdate(_ onUpdate: @escaping () -> Void) -> AnyView {
        inspect { _, _ in onUpdate() }
    }

}
