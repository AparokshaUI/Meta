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
            content.update = true
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
            guard let value = content.value as? Value else {
                return initialValue()
            }
            return value
        }
        nonmutating set {
            content.value = newValue
        }
    }

    /// Whether to force update the views when the value changes.
    var forceUpdates: Bool

    /// The closure for initializing the state property's value.
    var getInitialValue: () -> Value

    /// The content.
    let content: StateContent = .init()

    /// Initialize a property representing a state in the view with an autoclosure.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - id: An explicit identifier.
    ///     - forceUpdates: Whether to force update all available views when the property gets modified.
    public init(wrappedValue: @autoclosure @escaping () -> Value, forceUpdates: Bool = false) {
        getInitialValue = wrappedValue
        self.forceUpdates = forceUpdates
    }

    /// Get the initial value.
    /// - Returns: The initial value.
    func initialValue() -> Value {
        let initialValue = getInitialValue()
        let storage = StateContent.Storage(value: initialValue)
        if var model = initialValue as? Model {
            model.model = .init(storage: storage, force: forceUpdates)
            model.setup()
            content.storage = storage
            content.value = model
        } else {
            content.storage = storage
        }
        return initialValue
    }

    /// Set the storage up.
    func setup() {
        _ = initialValue()
    }

}
