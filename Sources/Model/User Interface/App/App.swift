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
///
///     var scene: Scene {
///         WindowScene()
///     }
///
/// }
/// ```
///
public protocol App {

    /// The app storage typ.
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
            for element in app.scene {
                element.setupInitialContainers(app: app.app)
            }
        }
    }

    /// Initialize and get the app with the app storage.
    ///
    /// To run the app, call the ``AppStorage/run(automaticSetup:manualSetup:)`` function.
    public static func setupApp() -> Self {
        var appInstance = self.init()
        appInstance.app = Storage(id: appInstance.id) { appInstance }
        StateManager.addUpdateHandler { force in
            var removeIndices: [Int] = []
            for (index, element) in appInstance.app.sceneStorage.enumerated() {
                if element.destroy {
                    removeIndices.insert(index, at: 0)
                } else if let scene = appInstance.scene.first(
                    where: { $0.id == element.id }
                ) as? Storage.SceneElementType as? SceneElement {
                    scene.update(element, app: appInstance.app, updateProperties: force)
                }
            }
            for index in removeIndices {
                appInstance.app.sceneStorage.remove(at: index)
            }
        }
        StateManager.appID = appInstance.id
        return appInstance
    }

}
