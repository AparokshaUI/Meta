//
//  AppStorage.swift
//  Meta
//
//  Created by david-swift on 01.07.24.
//

/// The app storage protocol.
public protocol AppStorage: AnyObject {

    /// The type of scene elements (which should be backend-specific).
    associatedtype SceneElementType

    /// The scene storage.
    var storage: StandardAppStorage { get set }

    /// Initialize the app storage.
    /// - Parameters id: The app's identifier.
    init(id: String)

    /// Run the application.
    /// - Parameter setup: A closure that is expected to be executed right at the beginning.
    func run(setup: @escaping () -> Void)

    /// Terminate the application.
    func quit()

}

extension AppStorage {

    /// Focus the scene element with a certain id (if supported). Create the element if it doesn't already exist.
    /// - Parameter id: The element's id.
    public func showSceneElement(_ id: String) {
        storage.sceneStorage.last { $0.id == id && !$0.destroy }?.show() ?? addSceneElement(id)
    }

    /// Add a new scene element with the content of the scene element with a certain id.
    /// - Parameter id: The element's id.
    public func addSceneElement(_ id: String) {
        if let element = storage.app?().scene.last(where: { $0.id == id }) {
            let container = element.container(app: self)
            storage.sceneStorage.append(container)
            showSceneElement(id)
        }
    }

    /// Focus the window with a certain id (if supported). Create the window if it doesn't already exist.
    /// - Parameter id: The window's id.
    public func showWindow(_ id: String) {
        showSceneElement(id)
    }

    /// Add a new window with the content of the window template with a certain id.
    /// - Parameter id: The window template's id.
    public func addWindow(_ id: String) {
        addSceneElement(id)
    }

}
