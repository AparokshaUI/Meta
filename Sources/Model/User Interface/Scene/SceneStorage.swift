//
//  SceneStorage.swift
//  Meta
//
//  Created by david-swift on 30.06.24.
//

/// Store a reference to a rendered scene element in a view storage.
public actor SceneStorage {

    /// The scene element's identifier.
    public var id: String
    /// The pointer.
    ///
    /// It can be a C pointer, a Swift class, or other information depending on the backend.
    public var pointer: Sendable?
    /// The scene element's view content.
    var content: [String: [ViewStorage]]
    /// Various properties of a scene element.
    var fields: [String: Sendable] = [:]
    /// Whether the reference to the window should disappear in the next update.
    public var destroy = false
    /// Show the scene element (including moving into the foreground, if possible).
    public var show: @Sendable () -> Void
    /// The previous state of the scene element.
    public var previousState: SceneElement?

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
        pointer: Sendable?,
        content: [String: [ViewStorage]] = [:],
        show: @Sendable @escaping () -> Void
    ) {
        self.id = id
        self.pointer = pointer
        self.content = content
        self.show = show
    }

    /// Set the pointer.
    /// - Parameter value: The new pointer.
    public func setPointer(_ value: Sendable?) {
        pointer = value
    }

    /// Set the element of a certain field.
    /// - Parameters:
    ///     - key: The key.
    ///     - value: The field.
    public func setField(key: String, value: Sendable) {
        fields[key] = value
    }

    /// Remove a certain field.
    /// - Parameters:
    ///     - key: The key.
    public func removeField(key: String) {
        fields.removeValue(forKey: key)
    }

    /// Get the element of a certain field.
    /// - Parameter key: The key.
    /// - Returns: The field.
    public func getField(key: String) -> Sendable? {
        fields[key]
    }

    /// Set the content elements under a certain key.
    /// - Parameters:
    ///     - key: The key.
    ///     - value: The content elements.
    public func setContent(key: String, value: [ViewStorage]) {
        content[key] = value
    }

    /// Get the content elements under a certain key.
    /// - Parameter key: The key.
    /// - Returns: The content elements.
    public func getContent(key: String) -> [ViewStorage] {
        content[key] ?? []
    }

    /// Set the previous state.
    /// - Parameter state: The state.
    public func setPreviousState(_ state: SceneElement?) {
        previousState = state
    }

    /// Set whether the scene will be destroyed.
    /// - Parameter destroy: Whether the scene will be destroyed.
    public func setDestroy(_ destroy: Bool) {
        self.destroy = destroy
    }

    /// Set the closure which shows the scene.
    /// - Parameter show: The closure.
    public func setShow(_ show: @Sendable @escaping () -> Void) {
        self.show = show
    }

}
