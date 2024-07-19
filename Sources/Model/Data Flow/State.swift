//
//  State.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

import Foundation

/// A property wrapper for properties in a view that should be stored throughout view updates.
@propertyWrapper
public struct State<Value>: StateProtocol {

    /// Access the stored value. This updates the views when being changed.
    public var wrappedValue: Value {
        get {
            rawValue
        }
        nonmutating set {
            rawValue = newValue
            StateManager.updateState(id: id)
            StateManager.updateViews(force: forceUpdates)
        }
    }

    /// Get the value as a binding using the `$` prefix.
    public var projectedValue: Binding<Value> {
        .init {
            wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
        }
    }

    /// Get and set the value without updating the views.
    public var rawValue: Value {
        get {
            guard let value = StateManager.getState(id: id) as? Value else {
                let initialValue = getInitialValue()
                StateManager.setState(id: id, value: initialValue)
                return initialValue
            }
            return value
        }
        nonmutating set {
            StateManager.setState(id: id, value: newValue)
        }
    }

    /// The state's identifier for the stored value.
    var id: UUID = .init()

    /// Whether to force update the views when the value changes.
    var forceUpdates: Bool

    /// The closure for initializing the state property's value.
    var getInitialValue: () -> Value

    /// Initialize a property representing a state in the view with an autoclosure.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - forceUpdates: Whether to force update all available views when the property gets modified.
    public init(wrappedValue: @autoclosure @escaping () -> Value, forceUpdates: Bool = false) {
        getInitialValue = wrappedValue
        self.forceUpdates = forceUpdates
    }

}
