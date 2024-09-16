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
    public var setProperty: (Pointer, Value, ViewStorage) -> Void
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
        set setProperty: @escaping (Pointer, Value, ViewStorage) -> Void,
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
        set setProperty: @escaping (Pointer, Value) -> Void,
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
        set setProperty: @escaping (Pointer, Value.Wrapped, ViewStorage) -> Void,
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
        set setProperty: @escaping (Pointer, Value.Wrapped) -> Void,
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
    var setProperty: (Pointer, Value, ViewStorage) -> Void { get }
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

    /// The view storage.
    /// - Parameters:
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let storage = ViewStorage(initializeWidget())
        initProperties(storage, data: data, type: type)
        update(storage, data: data, updateProperties: true, type: type)
        return storage
    }

    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: Modify views before being updated
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    ///
    /// This is the default implementation which requires the usage of ``Property``.
    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        self.updateProperties(storage, data: data, updateProperties: updateProperties, type: type)
        if updateProperties {
            storage.previousState = self
        }
    }

    /// Initialize the properties wrapped with ``Property``.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    public func initProperties<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        type: Data.Type
    ) where Data: ViewRenderData {
        let mirror = Mirror(reflecting: self)
        for property in mirror.children {
            if let value = property.value as? any ViewPropertyProtocol {
                let subview = value.wrappedValue.storage(data: data, type: type)
                initViewProperty(value, view: subview, parent: storage)
                storage.content[property.label ?? .mainContent] = [subview]
            }
            if let value = property.value as? any BindingPropertyProtocol {
                initBindingProperty(value, parent: storage)
            }
        }
    }

    /// Initialize the properties wrapped with ``ViewProperty``.
    /// - Parameters:
    ///     - value: The property.
    ///     - view: The subview's view storage.
    ///     - parent: The parent's view storage.
    func initViewProperty<Property>(
        _ value: Property,
        view: ViewStorage,
        parent: ViewStorage
    ) where Property: ViewPropertyProtocol {
        if let view = view.pointer as? Property.ViewPointer, let pointer = parent.pointer as? Property.Pointer {
            value.setView(pointer, view)
        }
    }

    /// Initialize a binding property.
    /// - Parameters:
    ///     - value: The property.
    ///     - parent: The view storage.
    func initBindingProperty<Property>(_ value: Property, parent: ViewStorage) where Property: BindingPropertyProtocol {
        if let view = parent.pointer as? Property.Pointer {
            value.observe(view, value.wrappedValue, parent)
        }
    }

    /// Update the properties wrapped with ``Property``.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - data: The widget data.
    ///     - updateProperties: Whether to update the view's properties.
    ///     - type: The view render data type.
    public func updateProperties<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        let mirror = Mirror(reflecting: self)
        updateNotEquatable(mirror: mirror, storage: storage, data: data, updateProperties: updateProperties, type: type)
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
    ///     - data: The widget data.
    ///     - updateProperties: Whether to update the properties.
    ///     - type: The view render data type.
    func updateNotEquatable<Data>(
        mirror: Mirror,
        storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        for property in mirror.children {
            if let value = property.value as? any PropertyProtocol {
                if value.updateStrategy == .always ||
                value.wrappedValue as? any Equatable == nil && value.updateStrategy != .alwaysWhenStateUpdate {
                    setProperty(property: value, storage: storage)
                }
            }
            if let value = property.value as? any ViewPropertyProtocol,
               let storage = storage.content[property.label ?? .mainContent]?.first {
               value.wrappedValue.updateStorage(storage, data: data, updateProperties: updateProperties, type: type)
            }
            if let value = property.value as? any BindingPropertyProtocol {
                setBindingProperty(property: value, storage: storage)
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
        if let pointer = storage.pointer as? Property.Pointer {
            property.setProperty(pointer, property.wrappedValue, storage)
        }
    }

    /// Apply a binding property to the framework.
    /// - Parameters:
    ///     - property: The property.
    ///     - storage: The view storage.
    func setBindingProperty<Property>(
        property: Property,
        storage: ViewStorage
    ) where Property: BindingPropertyProtocol {
        if let optional = property.wrappedValue.wrappedValue as? any OptionalProtocol, optional.optionalValue == nil {
            return
        }
        if let pointer = storage.pointer as? Property.Pointer {
            property.setValue(pointer, property.wrappedValue.wrappedValue, storage)
        }
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
