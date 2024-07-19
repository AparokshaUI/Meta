//
//  StateProtocol.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

import Foundation

/// An interface for accessing `State` without specifying the generic type.
protocol StateProtocol {

    /// The identifier for the state property's value.
    var id: UUID { get set }

}
