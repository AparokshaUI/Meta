//
//  Property.swift
//  Meta
//
//  Created by david-swift on 16.09.24.
//

/// Assign an observing and updating closure to a widget's binding property.
///
/// This will be used if you do not provide a custom ``Widget/update(_:data:updateProperties:type:)`` method
/// or call the ``Widget/updateProperties(_:updateProperties:)`` method in your custom update method.
@propertyWrapper
public struct BindingProperty<Value, Pointer>: BindingPropertyProtocol where Value: Sendable {

    /// The wrapped binding.
    public var wrappedValue: Binding<Value>
    /// Observe the UI element.
    var observe: @Sendable (Pointer, Binding<Value>, ViewStorage) async -> Void
    /// Set the UI element's property.
    var setValue: @Sendable (Pointer, Value, ViewStorage) async -> Void

    /// Initialize a property.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - getProperty: Get the property from the UI.
    ///     - setProperty: The function applying the property to the UI.
    ///     - pointer: The type of the pointer.
    public init(
        wrappedValue: Binding<Value>,
        observe: @Sendable @escaping (Pointer, Binding<Value>, ViewStorage) async -> Void,
        set setValue: @Sendable @escaping (Pointer, Value, ViewStorage) async -> Void,
        pointer: Pointer.Type
    ) {
        self.wrappedValue = wrappedValue
        self.observe = observe
        self.setValue = setValue
    }

    /// Initialize a property.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - getProperty: Get the property from the UI.
    ///     - setProperty: The function applying the property to the UI.
    ///     - pointer: The type of the pointer.
    public init(
        wrappedValue: Binding<Value>,
        observe: @Sendable @escaping (Pointer, Binding<Value>) async -> Void,
        set setValue: @Sendable @escaping (Pointer, Value) async -> Void,
        pointer: Pointer.Type
    ) {
        self.init(
            wrappedValue: wrappedValue,
            observe: { pointer, value, _ in await observe(pointer, value) },
            set: { pointer, value, _ in await setValue(pointer, value) },
            pointer: pointer
        )
    }

}

/// The binding property protocol.
protocol BindingPropertyProtocol: Sendable {

    /// The binding's wrapped value.
    associatedtype Value: Sendable
    /// The storage's pointer.
    associatedtype Pointer

    /// The wrapped value.
    var wrappedValue: Binding<Value> { get }
    /// Observe the property.
    var observe: @Sendable (Pointer, Binding<Value>, ViewStorage) async -> Void { get }
    /// Set the property.
    var setValue: @Sendable (Pointer, Value, ViewStorage) async -> Void { get }

}

extension Widget {

    /// Apply a binding property to the framework.
    /// - Parameters:
    ///     - property: The property.
    ///     - storage: The view storage.
    func setBindingProperty<Property>(
        property: Property,
        storage: ViewStorage
    ) async where Property: BindingPropertyProtocol {
        if let optional = property.wrappedValue.wrappedValue as? any OptionalProtocol, optional.optionalValue == nil {
            return
        }
        if let pointer = await storage.pointer as? Property.Pointer {
            await property.setValue(pointer, property.wrappedValue.wrappedValue, storage)
        }
    }

}
