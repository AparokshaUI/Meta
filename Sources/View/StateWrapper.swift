//
//  StateWrapper.swift
//  Meta
//
//  Created by david-swift on 09.06.24.
//

import Observation

/// A storage for `@State` properties.
public struct StateWrapper: ConvenienceWidget {

    /// The content.
    var content: () -> Body
    /// The state information (from properties with the `State` wrapper).
    var state: [String: StateProtocol] = [:]

    /// The debug tree parameters.
    public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
        [
            ("state", value: state.map { $0.key.dropFirst() }.joined(separator: ", "))
        ]
    }

    /// The debug tree's content.
    public var debugTreeContent: [(String, body: Body)] {
        [("content", body: content())]
    }

    /// The identifier of the field storing whether to update the wrapper's content.
    private var updateID: String { "update" }

    /// Initialize a `StateWrapper`.
    /// - Parameter content: The view content.
    public init(@ViewBuilder content: @escaping () -> Body) {
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
    ///     - type: The type of the widgets.
    public func update<WidgetType>(
        _ storage: ViewStorage,
        modifiers: [(AnyView) -> AnyView],
        updateProperties: Bool,
        type: WidgetType.Type
    ) {
        var updateProperties = storage.fields[updateID] as? Bool ?? false
        storage.fields[updateID] = false
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
        guard let storages = storage.content[.mainContent] else {
            return
        }
        content().update(storages, modifiers: modifiers, updateProperties: updateProperties, type: type)
    }

    /// Get a view storage.
    /// - Parameters:
    ///     - modifiers: Modify views before being updated.
    ///     - type: The type of the widgets.
    /// - Returns: The view storage.
    public func container<WidgetType>(modifiers: [(AnyView) -> AnyView], type: WidgetType.Type) -> ViewStorage {
        let content = content().storages(modifiers: modifiers, type: type)
        let storage = ViewStorage(nil, content: [.mainContent: content])
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
            _ = content().getDebugTree(parameters: true, type: AnyView.self)
        } onChange: {
            Task {
                StateManager.updateState(id: storage.state.first?.value.id ?? .init())
                StateManager.updateViews()
                observe(storage: storage)
            }
        }
    }

}
