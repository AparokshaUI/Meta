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
    ///     - type: The type of the widgets.
    public func updateStorage<WidgetType>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: WidgetType.Type
    ) {
        widget(modifiers: modifiers)
            .update(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

    /// Get a storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The widget types.
    /// - Returns: The storage.
    public func storage<WidgetType>(modifiers: [(AnyView) -> AnyView], type: WidgetType.Type) -> ViewStorage {
        widget(modifiers: modifiers).container(modifiers: modifiers, type: type)
    }

    /// Wrap the view into a widget.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The widget.
    public func widget(modifiers: [(AnyView) -> AnyView]) -> Widget {
        let modified = getModified(modifiers: modifiers)
        if let peer = modified as? Widget {
            return peer
        }
        if let array = modified as? Body {
            return Wrapper { array }
        }
        return Wrapper { viewContent.map { $0.getModified(modifiers: modifiers) } }
    }

    /// Whether the view can be rendered in a certain environment.
    func renderable<WidgetType>(type: WidgetType.Type, modifiers: [(AnyView) -> AnyView]) -> Bool {
        let result = getModified(modifiers: modifiers)
        return result as? WidgetType != nil
        || result as? SimpleView != nil
        || result as? View != nil
        || result as? ConvenienceWidget != nil
        || result as? Body != nil
    }

}

/// `Body` is an array of views.
public typealias Body = [AnyView]
