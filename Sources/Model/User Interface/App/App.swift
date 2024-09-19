//
//  App.swift
//  Meta
//
//  Created by david-swift on 01.07.24.
//

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
public protocol App: Sendable {

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

/// Extend the app.
extension App {

    /// The application's entry point.
    public static func main() {
        let app = setupApp()
        app.app.run {
            for element in app.scene where element is Storage.SceneElementType {
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
        StateManager.addUpdateHandler { [appInstance] force in
            let updateProperties = force || appInstance.getState().contains { $0.value.content.update }
            var removeIndices: [Int] = []
            for (index, element) in await appInstance.app.storage.sceneStorage.enumerated() {
                if await element.destroy {
                    removeIndices.insert(index, at: 0)
                } else if let scene = await appInstance.scene.first(
                    where: { await $0.id == element.id }
                ) as? Storage.SceneElementType as? SceneElement {
                    scene.update(element, app: appInstance.app, updateProperties: updateProperties)
                }
            }
            for index in removeIndices {
                await appInstance.app.modifyStandardAppStorage { $0.sceneStorage.remove(at: index) }
            }
        }
        StateManager.appID = appInstance.id
        Task { [appInstance] in
            let state = appInstance.getState()
            await appInstance.app.modifyStandardAppStorage { storage in
                storage.stateStorage = state
                storage.app = { appInstance }
            }
        }
        return appInstance
    }

    /// Get the state from the properties.
    /// - Returns: The state.
    func getState() -> [String: StateProtocol] {
        var state: [String: StateProtocol] = [:]
        for property in Mirror(reflecting: self).children {
            if let label = property.label, let value = property.value as? StateProtocol {
                state[label] = value
            }
        }
        return state
    }

}
