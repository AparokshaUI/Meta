//
//  StateWrapper.swift
//  Meta
//
//  Created by david-swift on 09.06.24.
//

import Observation

/// A storage for `@State` properties.
struct StateWrapper: ConvenienceWidget {

    /// The content.
    var content: () -> Body
    /// The state information (from properties with the `State` wrapper).
    var state: [String: StateProtocol] = [:]

    /// Initialize a `StateWrapper`.
    /// - Parameter content: The view content.
    init(@ViewBuilder content: @escaping () -> Body) {
        self.content = content
    }

    /// Initialize a `StateWrapper`.
    /// - Parameters:
    ///   - content: The view content.
    ///   - state: The state information.
    init(content: @escaping () -> Body, state: [String: StateProtocol]) {
        self.content = content
        self.state = state
    }

    /// Update a view storage.
    /// - Parameters:
    ///     - storage: The view storage.
    ///     - modifiers: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    ///     - type: The type of the app storage.
    func update<Storage>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: Storage.Type
    ) where Storage: AppStorage {
        var updateProperties = updateProperties
        for property in state {
            if let oldID = storage.state[property.key]?.id {
                StateManager.changeID(old: oldID, new: property.value.id)
                storage.state[property.key]?.id = property.value.id
            }
            if StateManager.getUpdateState(id: property.value.id) {
                updateProperties = true
                StateManager.updatedState(id: property.value.id)
            }
        }
        guard let storage = storage.content[.mainContent]?.first else {
            return
        }
        content().updateStorage(storage, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

    /// Get a view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the app storage.
    /// - Returns: The view storage.
    func container<Storage>(
        modifiers: [(AnyView) -> AnyView],
        type: Storage.Type
    ) -> ViewStorage where Storage: AppStorage {
        let content = content().storage(modifiers: modifiers, type: type)
        let storage = ViewStorage(content.pointer, content: [.mainContent: [content]])
        storage.state = state
        if #available(macOS 14, *), #available(iOS 17, *), state.contains(where: { $0.value.isObservable }) {
            observe(storage: storage)
        }
        return storage
    }

    /// Observe the observable properties accessed in the view.
    /// - Parameter storage: The view storage
    @available(macOS, introduced: 14)
    @available(iOS, introduced: 17)
    func observe(storage: ViewStorage) {
        withObservationTracking {
            _ = content()
        } onChange: {
            StateManager.updateState(id: storage.state.first?.value.id ?? .init())
            StateManager.updateViews()
            observe(storage: storage)
        }
    }

}
