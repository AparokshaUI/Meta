//
//  Signal.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

import Foundation

/// A type that signalizes an action.
public struct Signal: Model, Sendable {

    /// An action is signalized by toggling a boolean to `true` and back to `false`.
    var boolean = false
    /// A signal has a unique identifier.
    public let id: UUID = .init()
    /// The model data.
    public var model: ModelData?

    /// Whether the action has caused an update.
    public var update: Bool { boolean }

    /// Initialize a signal.
    public init() { }

    /// Activate a signal.
    public func signal() {
        setModel { $0.boolean = true }
    }

    /// Destroy a signal.
    mutating func destroySignal() {
        boolean = false
    }

}
