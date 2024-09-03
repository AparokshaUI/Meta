//
//  StateWrapper.swift
//  Meta
//
//  Created by david-swift on 09.06.24.
//

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
    ///     - data: Modify views before being updated.
    ///     - updateProperties: Whether to update properties.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        var updateProperties = updateProperties
        for property in state {
            if let storage = storage.state[property.key]?.content.storage {
                property.value.content.storage = storage
            }
            if property.value.content.update {
                updateProperties = true
                property.value.content.update = false
            }
        }
        guard let storage = storage.content[.mainContent]?.first else {
            return
        }
        content().updateStorage(storage, data: data, updateProperties: updateProperties, type: type)
    }

    /// Get a view storage.
    /// - Parameters:
    ///     - data: Modify views before being updated.
    ///     - type: The view render data type.
    /// - Returns: The view storage.
    func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let content = content().storage(data: data, type: type)
        let storage = ViewStorage(content.pointer, content: [.mainContent: [content]])
        storage.state = state
        for element in state {
            element.value.setup()
        }
        return storage
    }

}
