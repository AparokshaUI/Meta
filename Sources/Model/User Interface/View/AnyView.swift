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
    public func updateStorage<Data>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        widget(modifiers: modifiers, type: type)
            .update(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

    /// Get a storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The widget types.
    /// - Returns: The storage.
    public func storage<Data>(
        modifiers: [(AnyView) -> AnyView],
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        widget(modifiers: modifiers, type: type).container(modifiers: modifiers, type: type)
    }

    /// Wrap the view into a widget.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The widget.
    func widget<Data>(modifiers: [(AnyView) -> AnyView], type: Data.Type) -> Widget where Data: ViewRenderData {
        let modified = getModified(modifiers: modifiers)
        if let peer = modified as? Widget {
            return peer
        }
        if let array = modified as? Body {
            return Data.WrapperType { array }
        }
        return Data.WrapperType { viewContent.map { $0.getModified(modifiers: modifiers) } }
    }

    /// Whether the view can be rendered in a certain environment.
    func renderable<Data>(type: Data.Type, modifiers: [(AnyView) -> AnyView]) -> Bool where Data: ViewRenderData {
        let result = getModified(modifiers: modifiers)
        return result as? Data.WidgetType != nil
        || result as? SimpleView != nil
        || result as? View != nil
        || result as? ConvenienceWidget != nil
        || result as? Body != nil
    }

    /// Apply a modification onto a view.
    /// - Parameter action: The modifications.
    /// - Returns: The modified view.
    public func modify(action: (inout Self) -> Void) -> Self {
        var newSelf = self
        action(&newSelf)
        return newSelf
    }

}

/// `Body` is an array of views.
public typealias Body = [AnyView]
