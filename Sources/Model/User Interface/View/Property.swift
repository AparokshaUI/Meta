//
//  Property.swift
//  Meta
//
//  Created by david-swift on 12.09.24.
//

/// Assign an updating closure to a widget's property.
///
/// This will be used if you do not provide a custom ``Widget/update(_:data:updateProperties:type:)`` method
/// or call the ``Widget/updateProperties(_:updateProperties:)`` method in your custom update method.
@propertyWrapper
public struct Property<Value, Pointer>: PropertyProtocol {

    /// The function applying the property to the UI.
    public var setProperty: (Pointer?, Value, ViewStorage) -> Void
    /// The wrapped value.
    public var wrappedValue: Value
    /// The update strategy.
    public var updateStrategy: UpdateStrategy

    /// Initialize a property.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - setProperty: The function applying the property to the UI.
    ///     - pointer: The type of the pointer.
    ///     - updateStrategy: The update strategy, this should be ``UpdateStrategy/automatic`` in most cases.
    public init(
        wrappedValue: Value,
        set setProperty: @escaping (Pointer?, Value, ViewStorage) -> Void,
        pointer: Pointer.Type,
        updateStrategy: UpdateStrategy = .automatic
    ) {
        self.setProperty = setProperty
        self.wrappedValue = wrappedValue
        self.updateStrategy = updateStrategy
    }

    /// Initialize a property.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - setProperty: The function applying the property to the UI.
    ///     - pointer: The type of the pointer.
    ///     - updateStrategy: The update strategy, this should be ``UpdateStrategy/automatic`` in most cases.
    public init(
        wrappedValue: Value,
        set setProperty: @escaping (Pointer?, Value) -> Void,
        pointer: Pointer.Type,
        updateStrategy: UpdateStrategy = .automatic
    ) {
        self.init(
            wrappedValue: wrappedValue,
            set: { pointer, value, _ in setProperty(pointer, value) },
            pointer: pointer,
            updateStrategy: updateStrategy
        )
    }

}

extension Property where Value: OptionalProtocol {

    /// Initialize a property.
    /// - Parameters:
    ///     - setProperty: The function applying the property to the UI.
    ///     - pointer: The type of the pointer.
    ///     - updateStrategy: The update strategy, this should be ``UpdateStrategy/automatic`` in most cases.
    public init(
        set setProperty: @escaping (Pointer?, Value.Wrapped, ViewStorage) -> Void,
        pointer: Pointer.Type,
        updateStrategy: UpdateStrategy = .automatic
    ) {
        self.setProperty = { pointer, value, storage in
            if let value = value.optionalValue {
                setProperty(pointer, value, storage)
            }
        }
        wrappedValue = nil
        self.updateStrategy = updateStrategy
    }

    /// Initialize a property.
    /// - Parameters:
    ///     - wrappedValue: The wrapped value.
    ///     - setProperty: The function applying the property to the UI.
    ///     - pointer: The type of the pointer.
    ///     - updateStrategy: The update strategy, this should be ``UpdateStrategy/automatic`` in most cases.
    public init(
        set setProperty: @escaping (Pointer?, Value.Wrapped) -> Void,
        pointer: Pointer.Type,
        updateStrategy: UpdateStrategy = .automatic
    ) {
        self.init(
            set: { pointer, value, _ in setProperty(pointer, value) },
            pointer: pointer,
            updateStrategy: updateStrategy
        )
    }

}

/// The property protocol.
protocol PropertyProtocol {

    /// The type of the wrapped value.
    associatedtype Value
    /// The type of the view's pointer.
    associatedtype Pointer

    /// The wrapped value.
    var wrappedValue: Value { get }
    /// Set the property.
    var setProperty: (Pointer?, Value, ViewStorage) -> Void { get }
    /// The update strategy.
    var updateStrategy: UpdateStrategy { get }

}

/// The update strategy for properties.
public enum UpdateStrategy {

    /// If equatable, update only when the value changed.
    /// If not equatable, this is equivalent to ``UpdateStrategy/always``.
    case automatic
    /// Update always when an update is triggered.
    case always
    /// Update always when a state value in a parent view changed,
    /// regardless of the property's value.
    case alwaysWhenStateUpdate

}

extension Widget {

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    ///
    /// This is the default implementation which requires the usage of ``Property``.
    public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) {
        self.updateProperties(storage, updateProperties: updateProperties)
        if updateProperties {
            storage.previousState = self
        }
    }

    /// Update the properties wrapped with ``Property``.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - updateProperties: Whether to update the view's properties.
    public func updateProperties(_ storage: ViewStorage, updateProperties: Bool) {
        let mirror = Mirror(reflecting: self)
        updateNotEquatable(mirror: mirror, storage: storage)
        guard updateProperties else {
            return
        }
        updateAlwaysWhenStateUpdate(mirror: mirror, storage: storage)
        updateEquatable(mirror: mirror, storage: storage)
    }

    /// Update the properties which are not equatable and should always be updated (e.g. closures).
    /// - Parameters:
    ///     - mirror: A mirror of the widget.
    ///     - storage: The view storage.
    func updateNotEquatable(mirror: Mirror, storage: ViewStorage) {
        for property in mirror.children {
            if let value = property.value as? any PropertyProtocol {
                if value.updateStrategy == .always ||
                value.wrappedValue as? any Equatable == nil && value.updateStrategy != .alwaysWhenStateUpdate {
                    setProperty(property: value, storage: storage)
                }
            }
        }
    }

    /// Update the properties which should always be updated when a state property changed
    /// (e.g. "regular" properties which are not equatable).
    /// - Parameters:
    ///     - mirror: A mirror of the widget.
    ///     - storage: The view storage.
    ///
    /// Initialize the ``Property`` property wrapper with the ``UpdateStrategy/alwaysWhenStateUpdate``.
    func updateAlwaysWhenStateUpdate(mirror: Mirror, storage: ViewStorage) {
        for property in mirror.children {
            if let value = property.value as? any PropertyProtocol {
                if value.updateStrategy == .alwaysWhenStateUpdate {
                    setProperty(property: value, storage: storage)
                }
            }
        }
    }

    /// Update equatable properties (most properties).
    /// - Parameters:
    ///     - mirror: A mirror of the widget.
    ///     - storage: The view storage.
    func updateEquatable(mirror: Mirror, storage: ViewStorage) {
        let previousState: Mirror.Children? = if let previousState = storage.previousState {
            Mirror(reflecting: previousState).children
        } else {
            nil
        }
        for property in mirror.children {
            if let value = property.value as? any PropertyProtocol,
               value.updateStrategy == .automatic,
               let wrappedValue = value.wrappedValue as? any Equatable {
                var update = true
                if let previous = previousState?.first(where: { previousProperty in
                    previousProperty.label == property.label
                })?.value as? any PropertyProtocol,
                equal(previous, wrappedValue) {
                    update = false
                }
                if update {
                    setProperty(property: value, storage: storage)
                }
            }
        }
    }

    /// Check whether a property is equal to a value.
    /// - Parameters:
    ///     - property: The property.
    ///     - value: The value.
    /// - Returns: Whether the property and value are equal.
    func equal<Property, Value>(
        _ property: Property,
        _ value: Value
    ) -> Bool where Property: PropertyProtocol, Value: Equatable {
        if let propertyValue = property.wrappedValue as? Value {
            return propertyValue == value
        }
        return false
    }

    /// Apply a property to the framework.
    /// - Parameters:
    ///     - property: The property.
    ///     - storage: The view storage.
    func setProperty<Property>(property: Property, storage: ViewStorage) where Property: PropertyProtocol {
        if let optional = property.wrappedValue as? any OptionalProtocol, optional.optionalValue == nil {
            return
        }
        property.setProperty(storage.pointer as? Property.Pointer, property.wrappedValue, storage)
    }

}

/// A protocol for values which can be optional.
public protocol OptionalProtocol: ExpressibleByNilLiteral {

    /// The type of the wrapped value.
    associatedtype Wrapped

    /// The value.
    var optionalValue: Wrapped? { get }

}

extension Optional: OptionalProtocol {

    /// The optional value.
    public var optionalValue: Wrapped? {
        self
    }

}
