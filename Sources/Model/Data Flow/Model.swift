//
//  Model.swift
//  Meta
//
//  Created by david-swift on 19.07.2024.
//

import Foundation

/// A model is a special type of state which can be updated from within itself.
/// This is useful for complex asynchronous operations such as networking.
///
/// Use the model protocol in the following way:
/// ```swift
/// struct TestView: View {
///
///    @State private var test = TestModel()
///
///    var view: Body {
///        Button(test.test) {
///            test.updateAsync()
///            // You can also update via
///            // test.test = "hello"
///            // as with any state values
///        }
///    }
///
/// }
///
/// struct TestModel: Model {
///
///    var test = "Label"
///
///    var model: ModelData? // Use exactly this line in every model
///
///    func updateAsync() {
///        Task {
///            // Do something asynchronously
///            // Remember to execute the following line in the correct context, depending on the backend
///            // As an example, you might have to run it on the main thread in some cases
///            setModel { $0.test = "\(Int.random(in: 1...10))" }
///        }
///    }
///
/// }
///
/// ```
public protocol Model {

    /// Data about the model's state value.
    var model: ModelData? { get set }
    /// Set the model up.
    ///
    /// At the point this function gets called, the model data is available.
    /// Therefore, you can use it for initializing callbacks of children.
    mutating func setup()

}

/// Data about a model's state value.
public struct ModelData {

    /// The state value's identifier.
    var storage: StateContent.Storage
    /// Whether to force update the views when this value changes.
    var force: Bool

}

/// Extend the model.
extension Model {

    /// Get the value as a binding using the `$` prefix.
    public var binding: Binding<Self> {
        .init {
            getModel()
        } set: { newValue in
            guard let data = model else {
                return
            }
            data.storage.value = newValue
            data.storage.update = true
            StateManager.updateViews(force: data.force)
        }
    }

    /// Set the model up.
    ///
    /// At the point this function gets called, the model data is available.
    /// Therefore, you can use it for initializing callbacks of children.
    public mutating func setup() { }

    /// Update the model.
    /// - Parameter setModel: Update the model in this closure.
    public func setModel(_ setModel: (inout Self) -> Void) {
        guard let data = model else {
            return
        }
        var model = getModel()
        setModel(&model)
        data.storage.value = model
        data.storage.update = true
        StateManager.updateViews(force: data.force)
    }

    /// Get the current version of the model.
    /// - Returns: The model.
    ///
    /// This is only useful when calling from a context where the model itself is outdated.
    /// Otherwise, directly call the properties.
    public func getModel() -> Self {
        guard let data = model else {
            return self
        }
        return data.storage.value as? Self ?? self
    }

}
