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
            content.storage.update = true
            UpdateManager.updateViews(force: forceUpdates)
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

    // swiftlint:disable force_cast
    /// Get and set the value without updating the views.
    public var rawValue: Value {
        get {
            content.storage.value as! Value
        }
        nonmutating set {
            content.storage.value = newValue
            writeValue?(newValue)
        }
    }
    // swiftlint:enable force_cast

    /// The stored value.
    let content: StateContent

    /// Whether to force update the views when the value changes.
    public var forceUpdates: Bool

    /// The function for updating the value in the settings file.
    private var writeValue: ((Value) -> Void)?

    /// The value with an erased type.
    public var value: Any {
        get {
            wrappedValue
        }
        nonmutating set {
            if let newValue = newValue as? Value {
                content.storage.value = newValue
            }
        }
    }

    /// Initialize a property representing a state in the view with an autoclosure.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - forceUpdates: Whether to force update all available views when the property gets modified.
    public init(wrappedValue: @autoclosure @escaping () -> Value, forceUpdates: Bool = false) {
        content = .init(getInitialValue: wrappedValue)
        self.forceUpdates = forceUpdates
    }

}
