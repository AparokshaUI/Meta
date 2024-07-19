//
//  App.swift
//  Meta
//
//  Created by david-swift on 01.07.24.
//

import Observation

/// A structure conforming to `App` is the entry point of your app.
///
/// ```swift
/// @main
/// struct Test: App {
///
///     let id = "io.github.AparokshaUI.TestApp"
///     var app: BackendApp!
///
///     var scene: Scene {
///         WindowScene()
///     }
///
/// }
/// ```
///
public protocol App {

    /// The app storage type.
    associatedtype Storage: AppStorage

    /// The app's application ID.
    var id: String { get }
    /// The app's scene.
    @SceneBuilder var scene: Scene { get }
    // swiftlint:disable implicitly_unwrapped_optional
    /// The app storage.
    var app: Storage! { get set }
    // swiftlint:enable implicitly_unwrapped_optional

    /// An app has to have an `init()` initializer.
    init()

}

extension App {

    /// The application's entry point.
    public static func main() {
        let app = setupApp()
        app.app.run {
            for element in app.scene where element as? Storage.SceneElementType != nil {
                element.setupInitialContainers(app: app.app)
            }
        }
    }

    /// Initialize and get the app with the app storage.
    /// - Returns: The app instance.
    ///
    /// To run the app, call the ``AppStorage/run(setup:)`` function.
    public static func setupApp() -> Self {
        var appInstance = self.init()
        appInstance.app = Storage(id: appInstance.id)
        appInstance.app.storage.app = { appInstance }
        StateManager.addUpdateHandler { force in
            var updateProperties = force
            for property in appInstance.getState() {
                if let oldID = appInstance.app.storage.stateStorage[property.key]?.id {
                    StateManager.changeID(old: oldID, new: property.value.id)
                    appInstance.app.storage.stateStorage[property.key]?.id = property.value.id
                }
                if StateManager.getUpdateState(id: property.value.id) {
                    updateProperties = true
                    StateManager.updatedState(id: property.value.id)
                }
            }
            var removeIndices: [Int] = []
            for (index, element) in appInstance.app.storage.sceneStorage.enumerated() {
                if element.destroy {
                    removeIndices.insert(index, at: 0)
                } else if let scene = appInstance.scene.first(
                    where: { $0.id == element.id }
                ) as? Storage.SceneElementType as? SceneElement {
                    scene.update(element, app: appInstance.app, updateProperties: updateProperties)
                }
            }
            for index in removeIndices {
                appInstance.app.storage.sceneStorage.remove(at: index)
            }
        }
        StateManager.appID = appInstance.id
        let state = appInstance.getState()
        appInstance.app.storage.stateStorage = state
        if #available(macOS 14, *), #available(iOS 17, *), state.contains(where: { $0.value.isObservable }) {
            appInstance.observe()
        }
        return appInstance
    }

    func getState() -> [String: StateProtocol] {
        var state: [String: StateProtocol] = [:]
        for property in Mirror(reflecting: self).children {
            if let label = property.label, let value = property.value as? StateProtocol {
                state[label] = value
            }
        }
        return state
    }

    /// Observe the observable properties accessed in the app.
    @available(macOS, introduced: 14)
    @available(iOS, introduced: 17)
    func observe() {
        withObservationTracking {
            _ = scene
        } onChange: {
            StateManager.updateState(id: app.storage.stateStorage.first?.value.id ?? .init())
            StateManager.updateViews()
            observe()
        }
    }

}
