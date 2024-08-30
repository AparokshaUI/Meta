//
//  ModifierStopper.swift
//  Meta
//
//  Created by david-swift on 29.06.24.
//

/// Remove all of the content data for the wrapped views.
struct ModifierStopper: ConvenienceWidget {

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
        content.storage(data: data.noModifiers, type: type)
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
        content.updateStorage(storage, data: data.noModifiers, updateProperties: updateProperties, type: type)
    }

}

/// Extend any view.
extension AnyView {

    /// Remove all of the content data for the wrapped views.
    /// - Returns: A view.
    public func stopModifiers() -> AnyView {
        ModifierStopper(content: self)
    }

}
