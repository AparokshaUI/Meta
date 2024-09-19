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
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) async -> ViewStorage where Data: ViewRenderData

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) async where Data: ViewRenderData

    /// Get the widget.
    /// - Returns: The widget.
    ///
    /// Define this function only if you do not define ``Widget/container(data:type:)``.
    /// Otherwise, it will not have an effect.
    func initializeWidget() -> Sendable

}

/// Extend the widget type.
extension Widget {

    /// A widget's view is empty.
    public var viewContent: Body { [] }

    /// Print a warning if the widget does not set this function but it gets accessed.
    /// - Returns: A dummy pointer.
    public func initializeWidget() -> Sendable {
        print("Warning: Define initialize widget function or container function for \(Self.self)")
        return ""
    }

}
