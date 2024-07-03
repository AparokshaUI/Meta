//
//  ViewStorage.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// Store a reference to a rendered view in a view storage.
public class RenderableStorage {

    /// The pointer.
    ///
    /// It can be a C pointer, a Swift class, or other information depending on the backend and renderable type.
    public var pointer: Any?
    /// Various properties of a widget.
    public var fields: [String: Any] = [:]

    /// The pointer as an opaque pointer, as this is may be needed with backends interoperating with C or C++.
    public var opaquePointer: OpaquePointer? {
        get {
            pointer as? OpaquePointer
        }
        set {
            pointer = newValue
        }
    }

    /// Initialize a renderable storage.
    /// - Parameter pointer: The pointer to the renderable element, its type depends on the backend.
    public init(_ pointer: Any?, content: [String: [ViewStorage]] = [:]) {
        self.pointer = pointer
    }

}
