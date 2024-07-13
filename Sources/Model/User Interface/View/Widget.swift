//
//  Widget.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// A widget is a view that know about its native backend widget.
///
/// It enables the translation from the declarative definition to the creation 
/// and updating of widgets in an imperative way.
public protocol Widget: AnyView {

    /// The view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the app storage.
    func container<Data>(
        modifiers: [(AnyView) -> AnyView],
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - modifiers: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The type of the app storage.
    func update<Data>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData

}

extension Widget {

    /// A widget's view is empty.
    public var viewContent: Body { [] }

}
