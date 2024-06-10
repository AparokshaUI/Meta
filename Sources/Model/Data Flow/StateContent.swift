//
//  StateContent.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// A class storing the state's content.
class StateContent {

    /// The storage.
    var storage: Storage {
        get {
            if let internalStorage {
                return internalStorage
            }
            let value = getInitialValue()
            let storage = Storage(value: value)
            internalStorage = storage
            return storage
        }
        set {
            internalStorage = newValue
        }
    }
    /// The internal storage.
    var internalStorage: Storage?
    /// The initial value.
    private var getInitialValue: () -> Any

    /// Initialize the content without already initializing the storage or initializing the value.
    /// - Parameter initialValue: The initial value.
    init(getInitialValue: @escaping () -> Any) {
        self.getInitialValue = getInitialValue
    }

    /// A class storing the value.
    class Storage {

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
