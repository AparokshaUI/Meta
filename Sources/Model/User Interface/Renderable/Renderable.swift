//
//  Renderable.swift
//  Meta
//
//  Created by david-swift on 03.07.24.
//

/// A structure conforming to `Renderable` is a more limited UI type similar to a view, e.g. a menu.
public protocol Renderable {

    /// The view storage.
    /// - Parameters:
    ///     - type: The type of the renderable elements.
    ///     - fields: More information.
    func container<RenderableType>(type: RenderableType.Type, fields: [String: Any]) -> RenderableStorage

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - updateProperties: Whether to update the properties.
    ///     - type: The type of the renderable elements.
    ///     - fields:
    func update<RenderableType>(
        _ storage: RenderableStorage,
        updateProperties: Bool,
        type: RenderableType.Type,
        fields: [String: Any]
    )

}
