//
//  Wrapper.swift
//  Meta
//
//  Created by david-swift on 27.05.24.
//

/// Wrap a view into a single widget.
public struct Wrapper: Widget {

    /// The content.
    var content: Body

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        []
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        [("content", body: content)]
    }

    /// Initialize a `Wrapper`.
    /// - Parameter content: The view content.
    public init(@ViewBuilder content: @escaping () -> Body) {
        self.content = content()
    }

    /// Update a view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    public func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
        if let storage = storage.content[.mainContent]?.first {
            content
                .widget(modifiers: modifiers)
                .update(storage, modifiers: modifiers, updateProperties: updateProperties)
        }
    }

    /// Get a view storage.
    /// - Parameter modifiers: Modify views before being updated.
    /// - Returns: The view storage.
    public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
        let content = content.widget(modifiers: modifiers).container(modifiers: modifiers)
        return .init(content.pointer, content: [.mainContent: [content]])
    }

}
