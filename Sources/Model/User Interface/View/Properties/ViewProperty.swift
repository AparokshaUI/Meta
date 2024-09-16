//
//  Property.swift
//  Meta
//
//  Created by david-swift on 16.09.24.
//

/// Assign an updating closure to a widget's property.
///
/// This will be used if you do not provide a custom ``Widget/update(_:data:updateProperties:type:)`` method
/// or call the ``Widget/updateProperties(_:updateProperties:)`` method in your custom update method.
@propertyWrapper
public struct ViewProperty<Pointer, ViewPointer>: ViewPropertyProtocol {

    /// The wrapped value.
    public var wrappedValue: Body = []
    /// Set the view.
    var setView: (Pointer, ViewPointer) -> Void

    /// Initialize a property.
    /// - Parameters:
    ///     - setView: Set the view.
    ///     - pointer: The pointer type of the parent view (usually a concrete view type).
    ///     - subview: The pointer type of the child view (usually a protocol, view class, or similar).
    public init(
        set setView: @escaping (Pointer, ViewPointer) -> Void,
        pointer: Pointer.Type,
        subview: ViewPointer.Type
    ) {
        self.setView = setView
    }

}

/// The view property protocol.
///
/// Do not use for wrapper widgets.
protocol ViewPropertyProtocol {

    /// The type of the view's pointer.
    associatedtype Pointer
    /// The type of the view's content.
    associatedtype ViewPointer

    /// The wrapped value.
    var wrappedValue: Body { get }
    /// Set the view.
    var setView: (Pointer, ViewPointer) -> Void { get }

}
