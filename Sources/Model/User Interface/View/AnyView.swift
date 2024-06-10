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

    /// Get the view's debug tree.
    /// - Parameter parameters: Whether the widget parameters should be included in the debug tree.
    /// - Returns: A textual description.
    public func getDebugTree<ViewType>(parameters: Bool, type: ViewType.Type) -> String {
        if let body = self as? Body {
            return body.getBodyDebugTree(parameters: parameters, type: type)
        }
        return """
        \(Self.self) {
            \(indented: viewContent.getBodyDebugTree(parameters: parameters, type: type))
        }
        """
    }

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
    public func updateStorage(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        let modified = getModified(modifiers: modifiers)
        if let widget = modified as? Widget {
            widget.update(storage, modifiers: modifiers, updateProperties: updateProperties)
        } else {
            Wrapper { viewContent }
                .update(storage, modifiers: modifiers, updateProperties: updateProperties)
        }
    }

    /// Get a storage.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The storage.
    public func storage(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        widget(modifiers: modifiers).container(modifiers: modifiers)
    }

    /// Wrap the view into a widget.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The widget.
    public func widget(modifiers: [(AnyView) -> AnyView]) -> Widget {
        let modified = getModified(modifiers: modifiers)
        if let peer = modified as? Widget {
            return peer
        }
        return Wrapper { viewContent }
    }

}

/// `Body` is an array of views.
public typealias Body = [AnyView]
