//
//  EitherView.swift
//  Meta
//
//  Created by david-swift on 06.08.24.
//

/// A view building conditional bodies.
public protocol EitherView: AnyView {

    /// Initialize the either view.
    /// - Parameters:
    ///     - condition: Whether the first view is visible-
    ///     - view1: The first view, visible if true.
    ///     - view2: The second view, visible if false.
    init(
        _ condition: Bool,
        @ViewBuilder view1: () -> Body,
        @ViewBuilder else view2: () -> Body
    )

}
