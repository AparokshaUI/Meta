//
//  ViewStorage.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// Store a rendered view in a view storage.
public class ViewStorage {

    /// The pointer.
    public var pointer: Any?
    /// The view's content.
    public var content: [String: [ViewStorage]]
    /// The view's state (used in `StateWrapper`).
    var state: [String: StateProtocol] = [:]
    /// Other properties.
    public var fields: [String: Any] = [:]

    /// The pointer as an opaque pointer.
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
    ///   - content: The view's content.
    public init(
        _ pointer: Any?,
        content: [String: [ViewStorage]] = [:]
    ) {
        self.pointer = pointer
        self.content = content
    }

}
