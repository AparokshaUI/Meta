//
//  AnyView.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// The view type used for any form of a view.
public protocol AnyView {

    /// The view's content.
    @ViewBuilder var viewContent: Body { get }

}

extension AnyView {

    func getModified(modifiers: [(AnyView) -> AnyView]) -> AnyView {
        var modified: AnyView = self
        for modifier in modifiers {
            modified = modifier(modified)
        }
        return modified
    }

    /// Update a storage to a view.
    /// - Parameters:
    ///     - storage: The storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    ///     - type: The type of the app storage.
    public func updateStorage<Storage>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: Storage.Type
    ) where Storage: AppStorage {
        widget(modifiers: modifiers, type: type)
            .update(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

    /// Get a storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The widget types.
    /// - Returns: The storage.
    public func storage<Storage>(
        modifiers: [(AnyView) -> AnyView],
        type: Storage.Type
    ) -> ViewStorage where Storage: AppStorage {
        widget(modifiers: modifiers, type: type).container(modifiers: modifiers, type: type)
    }

    /// Wrap the view into a widget.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The widget.
    func widget<Storage>(modifiers: [(AnyView) -> AnyView], type: Storage.Type) -> Widget where Storage: AppStorage {
        let modified = getModified(modifiers: modifiers)
        if let peer = modified as? Widget {
            return peer
        }
        if let array = modified as? Body {
            return Storage.WrapperType { array }
        }
        return Storage.WrapperType { viewContent.map { $0.getModified(modifiers: modifiers) } }
    }

    /// Whether the view can be rendered in a certain environment.
    func renderable<Storage>(type: Storage.Type, modifiers: [(AnyView) -> AnyView]) -> Bool where Storage: AppStorage {
        let result = getModified(modifiers: modifiers)
        return result as? Storage.WidgetType != nil
        || result as? SimpleView != nil
        || result as? View != nil
        || result as? ConvenienceWidget != nil
        || result as? Body != nil
    }

}

/// `Body` is an array of views.
public typealias Body = [AnyView]
