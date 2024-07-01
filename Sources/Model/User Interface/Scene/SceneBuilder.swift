//
//  SceneBuilder.swift
//  Meta
//
//  Created by david-swift on 30.06.24.
//

import Foundation

/// The ``SceneBuilder`` is a result builder for scenes.
@resultBuilder
public enum SceneBuilder {

    /// A component used in the ``SceneBuilder``.
    public enum Component {

        /// A scene as a component.
        case element(_: any SceneElement)
        /// An array of components as a component.
        case components(_: [Self])

    }

    /// Build combined results from statement blocks.
    /// - Parameter components: The components.
    /// - Returns: The components in a component.
    public static func buildBlock(_ elements: Component...) -> Component {
        .components(elements)
    }

    /// Translate an element into a ``SceneBuilder.Component``.
    /// - Parameter element: The element to translate.
    /// - Returns: A component created from the element.
    public static func buildExpression(_ element: any SceneElement) -> Component {
        .element(element)
    }

    /// Translate an array of elements into a ``SceneBuilder.Component``.
    /// - Parameter elements: The elements to translate.
    /// - Returns: A component created from the element.
    public static func buildExpression(_ elements: [any SceneElement]) -> Component {
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
    public static func buildFinalResult(_ component: Component) -> Scene {
        switch component {
        case let .element(element):
            return [element]
        case let .components(components):
            return components.flatMap { buildFinalResult($0) }
        }
    }

}
