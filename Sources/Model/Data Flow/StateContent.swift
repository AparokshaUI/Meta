//
//  StateContent.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// A class storing the state's content.
final class StateContent: @unchecked Sendable {

    /// The storage.
    var storage: Storage?

    /// The value.
    var value: Any? {
        get {
            storage?.value
        }
        set {
            if let storage {
                storage.value = newValue as Any
            } else {
                storage = .init(value: newValue as Any)
            }
        }
    }

    /// Whether to update the views.
    var update: Bool {
        get {
            storage?.update ?? false
        }
        set {
            storage?.update = newValue
        }
    }

    /// Initialize the content without already initializing the storage or initializing the value.
    init() { }

    /// A class storing the value.
    class Storage: @unchecked Sendable {

        /// The stored value.
        var value: Any
        /// Whether to update the affected views.
        var update = false

        /// Initialize the storage.
        /// - Parameters:
        ///     - value: The value.
        init(value: Any) {
            self.value = value
        }

    }

}
