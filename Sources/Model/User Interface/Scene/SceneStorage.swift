//
//  SceneStorage.swift
//  Meta
//
//  Created by david-swift on 30.06.24.
//

/// Store a reference to a rendered scene element in a view storage.
public class SceneStorage {

    /// The scene element's identifier.
    public var id: String
    /// The pointer.
    ///
    /// It can be a C pointer, a Swift class, or other information depending on the backend,
    /// or it can be left out.
    public var pointer: Any?
    /// The scene element's view content.
    public var content: [String: [ViewStorage]]
    /// Various properties of a scene element.
    public var fields: [String: Any] = [:]
    /// Whether the reference to the window should disappear in the next update.
    public var destroy = false
    /// Show the scene element (including moving into the foreground, if possible).
    public var show: () -> Void

    /// The pointer as an opaque pointer, as this may be needed with backends interoperating with C or C++.
    public var opaquePointer: OpaquePointer? {
        get {
            pointer as? OpaquePointer
        }
        set {
            pointer = newValue
        }
    }

    /// Initialize a scene storage.
    /// - Parameters:
    ///   - id: The scene element's identifier.
    ///   - pointer: The pointer to the widget, its type depends on the backend.
    ///   - content: The view's content for container widgets.
    ///   - show: Function called when the scene element should be displayed.
    public init(
        id: String,
        pointer: Any?,
        content: [String: [ViewStorage]] = [:],
        show: @escaping () -> Void
    ) {
        self.id = id
        self.pointer = pointer
        self.content = content
        self.show = show
    }

}
