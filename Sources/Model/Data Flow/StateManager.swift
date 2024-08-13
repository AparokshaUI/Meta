//
//  StateManager.swift
//  Meta
//
//  Created by david-swift on 21.06.24.
//

import Foundation

/// This type manages view updates.
public enum StateManager {

    /// Whether to block updates in general.
    public static var blockUpdates = false
    /// Whether to save state.
    public static var saveState = true
    /// The application identifier.
    static var appID: String?
    /// The functions handling view updates.
    static var updateHandlers: [(Bool) -> Void] = []
    /// The state.
    static var state: [State] = []

    /// Information about a piece of state.
    struct State {

        /// The state's identifier.
        var id: String
        /// Old identifiers of the state which need to be saved.
        var oldIDs: [String] = []
        /// The state value.
        var value: Any?
        /// Whether to update in the next iteration.
        var update = false

        /// Whether the state's identifiers contain a certain identifier.
        /// - Parameter id: The identifier.
        /// - Returns: Whether the id is contained.
        func contains(id: String) -> Bool {
            id == self.id || oldIDs.contains(id)
        }

        /// Change the identifier to a new one.
        /// - Parameter newID: The new identifier.
        mutating func changeID(new newID: String) {
            id = newID
        }

    }

    /// Update all of the views.
    /// - Parameter force: Whether to force all views to update.
    ///
    /// Nothing happens if ``StateManager/blockUpdates`` is true.
    public static func updateViews(force: Bool = false) {
        if !blockUpdates {
            for handler in updateHandlers {
                handler(force)
            }
            for state in state where state.update {
                updatedState(id: state.id)
            }
        }
    }

    /// Add a handler that is called when the user interface should update.
    /// - Parameter handler: The handler. The parameter defines whether the whole UI should be force updated.
    static func addUpdateHandler(handler: @escaping (Bool) -> Void) {
        updateHandlers.append(handler)
    }

    /// Set the state value for a certain ID.
    /// - Parameters:
    ///   - id: The identifier.
    ///   - value: The new value.
    static func setState(id: String, value: Any?) {
        if saveState {
            guard let index = state.firstIndex(where: { $0.contains(id: id) }) else {
                state.append(.init(id: id, value: value))
                return
            }
            state[safe: index]?.value = value
        }
    }

    /// Get the state value for a certain ID.
    /// - Parameter id: The identifier.
    /// - Returns: The value.
    static func getState(id: String) -> Any? {
        state[safe: state.firstIndex { $0.contains(id: id) }]?.value
    }

    /// Mark the state of a certain id as updated.
    /// - Parameter id: The identifier.
    static func updateState(id: String) {
        if saveState {
            state[safe: state.firstIndex { $0.contains(id: id) }]?.update = true
        }
    }

    /// Mark the state of a certain id as not updated.
    /// - Parameter id: The identifier.
    static func updatedState(id: String) {
        if saveState {
            state[safe: state.firstIndex { $0.contains(id: id) }]?.update = false
        }
    }

    /// Get whether to update the state of a certain id.
    /// - Parameter id: The identifier.
    /// - Returns: Whether to update the state.
    static func getUpdateState(id: String) -> Bool {
        state[safe: state.firstIndex { $0.contains(id: id) }]?.update ?? false
    }

    /// Change the identifier for a certain state value.
    /// - Parameters:
    ///   - oldID: The old identifier.
    ///   - newID: The new identifier.
    static func changeID(old oldID: String, new newID: String) {
        if saveState {
            state[safe: state.firstIndex { $0.contains(id: oldID) }]?.changeID(new: newID)
        }
    }

    /// Save a state's identifier until the program ends.
    /// - Parameter id: The identifier.
    static func addConstantID(_ id: String) {
        state[safe: state.firstIndex { $0.id == id }]?.oldIDs.append(id)
    }

}
