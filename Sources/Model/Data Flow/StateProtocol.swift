//
//  StateProtocol.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// An interface for accessing `State` without specifying the generic type.
protocol StateProtocol {

    /// The `StateContent`.
    var content: StateContent { get }

}
