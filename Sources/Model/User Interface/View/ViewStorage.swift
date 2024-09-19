//
//  ViewStorage.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// Store a reference to a rendered view in a view storage.
public actor ViewStorage: Sendable {

    /// The pointer.
    ///
    /// It can be a C pointer, a Swift class, or other information depending on the backend.
    public var pointer: Sendable?
    /// The view's content for container widgets.
    var content: [String: [ViewStorage]]
    /// The view's state (used in `StateWrapper`).
    var state: [String: StateProtocol] = [:]
    /// Various properties of a widget.
    var fields: [String: Sendable] = [:]
    /// The previous state of the widget.
    public var previousState: Widget?

    /// The pointer as an opaque pointer, as this is needed with backends interoperating with C or C++.
    public var opaquePointer: Pointer? {
        get {
            pointer as? Pointer
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
        _ pointer: Sendable?,
        content: [String: [ViewStorage]] = [:],
        state: Widget? = nil
    ) {
        self.pointer = pointer
        self.content = content
        self.previousState = state
    }

    /// Set the state under a certain key.
    /// - Parameters:
    ///     - key: The key.
    ///     - value: The state.
    func setState(key: String, value: StateProtocol) {
        state[key] = value
    }

    /// Set the state.
    /// - Parameter state: The state.
    func setState(_ state: [String: StateProtocol]) {
        self.state = state
    }

    /// Get the state under a certain key.
    /// - Parameter key: The key.
    /// - Returns: The state.
    func getState(key: String) -> StateProtocol? {
        state[key]
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
    public func setPreviousState(_ state: Widget?) {
        previousState = state
    }

}
