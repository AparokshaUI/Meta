//
//  DummyEitherView.swift
//  Meta
//
//  Created by david-swift on 06.08.24.
//

/// A dummy either view. This will be replaced by the platform-specific either view.
struct DummyEitherView: SimpleView {

    /// Whether to present the first view.
    var condition: Bool
    /// The first view.
    var view1: Body?
    /// The second view.
    var view2: Body?

    /// By default, show the first view.
    var view: Body { view1 ?? view2 ?? [] }

}
