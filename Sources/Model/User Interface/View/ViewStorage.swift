//
//  ViewStorage.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// Store a reference to a rendered view in a view storage.
public class ViewStorage {

    /// The pointer.
    ///
    /// It can be a C pointer, a Swift class, or other information depending on the backend.
    /// Some convenience widgets do not need a pointer to a native framework at all.
    public var pointer: Any?
    /// The view's content for container widgets.
    public var content: [String: [ViewStorage]]
    /// The view's state (used in `StateWrapper`).
    var state: [String: StateProtocol] = [:]
    /// Various properties of a widget.
    public var fields: [String: Any] = [:]

    /// The pointer as an opaque pointer, as this is needed with backends interoperating with C or C++.
    public var opaquePointer: OpaquePointer? {
        get {
            pointer as? OpaquePointer
        }
        set {
            pointer = newValue
        }
    }

    /// Initialize a view storage.
    /// - Parameters:
    ///   - pointer: The pointer to the widget, its type depends on the backend.
    ///   - content: The view's content for container widgets.
    public init(
        _ pointer: Any?,
        content: [String: [ViewStorage]] = [:]
    ) {
        self.pointer = pointer
        self.content = content
    }

}
