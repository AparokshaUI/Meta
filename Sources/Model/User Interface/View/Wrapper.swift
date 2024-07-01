//
//  Wrapper.swift
//  Meta
//
//  Created by david-swift on 01.07.24.
//

/// Wrap a body into a single widget.
public protocol Wrapper: Widget {

    /// Initialize a `Wrapper`.
    /// - Parameter content: The view content.
    init(@ViewBuilder content: @escaping () -> Body)

}
