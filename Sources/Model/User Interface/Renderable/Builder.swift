//
//  Builder.swift
//  Meta
//
//  Created by david-swift on 03.07.24.
//

import Foundation

/// The ``Builder`` is a result builder for scenes.
@resultBuilder
public enum Builder<RenderableType> {

    /// A component used in the ``MenuBuilder``.
    public enum Component {

        /// A renderable element as a component.
        case element(_: RenderableType)
        /// An array of components as a component.
        case components(_: [Self])

    }

    /// Build combined results from statement blocks.
    /// - Parameter components: The components.
    /// - Returns: The components in a component.
    public static func buildBlock(_ elements: Component...) -> Component {
        .components(elements)
    }

    /// Translate an element into a ``MenuBuilder.Component``.
    /// - Parameter element: The element to translate.
    /// - Returns: A component created from the element.
    public static func buildExpression(_ element: RenderableType) -> Component {
        .element(element)
    }

    /// Translate an array of elements into a ``MenuBuilder.Component``.
    /// - Parameter elements: The elements to translate.
    /// - Returns: A component created from the element.
    public static func buildExpression(_ elements: [RenderableType]) -> Component {
        var components: [Component] = []
        for element in elements {
            components.append(.element(element))
        }
        return .components(components)
    }

    /// Fetch a component.
    /// - Parameter component: A component.
    /// - Returns: The component.
    public static func buildExpression(_ component: Component) -> Component {
        component
    }

    /// Convert a component to an array of elements.
    /// - Parameter component: The component to convert.
    /// - Returns: The generated array of elements.
    public static func buildFinalResult(_ component: Component) -> [RenderableType] {
        switch component {
        case let .element(element):
            return [element]
        case let .components(components):
            return components.flatMap { buildFinalResult($0) }
        }
    }

}
