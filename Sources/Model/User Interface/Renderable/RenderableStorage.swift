//
//  ViewStorage.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// Store a reference to a rendered element in a renderable storage.
public class RenderableStorage {

    /// The pointer.
    ///
    /// It can be a C pointer, a Swift class, or other information depending on the backend and renderable type.
    public var pointer: Any?
    /// Various properties of a widget.
    public var fields: [String: Any] = [:]
    /// Other renderable storage elements.
    public var content: [String: [RenderableStorage]] = [:]

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
    /// - Parameters:
    ///     - pointer: The pointer to the renderable element, its type depends on the backend.
    ///     - content: Other renderable storages.
    public init(_ pointer: Any?, content: [String: [RenderableStorage]] = [:]) {
        self.pointer = pointer
        self.content = content
    }

}
