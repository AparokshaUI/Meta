//
//  AppStorage.swift
//  Meta
//
//  Created by david-swift on 01.07.24.
//

/// The app storage protocol.
public protocol AppStorage: Actor, Sendable {

    /// The type of scene elements (which should be backend-specific).
    associatedtype SceneElementType

    /// The scene storage.
    var storage: StandardAppStorage { get set }

    /// Initialize the app storage.
    /// - Parameters id: The app's identifier.
    init(id: String)

    /// Run the application.
    /// - Parameter setup: A closure that is expected to be executed right at the beginning.
    nonisolated func run(setup: @escaping () -> Void)

    /// Terminate the application.
    nonisolated func quit()

}

extension AppStorage {

    /// Modify the app storage.
    /// - Parameter modify: The modifications.
    func modifyStandardAppStorage(_ modify: (inout StandardAppStorage) -> Void) {
        var copy = storage
        modify(&copy)
        self.storage = copy
    }

    /// Append a scene.
    /// - Parameter scene: The scene.
    public func appendScene(_ scene: SceneStorage) {
        modifyStandardAppStorage { $0.sceneStorage.append(scene) }
    }

}

/// Extend the app storage.
extension AppStorage {

    /// Focus the scene element with a certain id (if supported). Create the element if it doesn't already exist.
    /// - Parameter id: The element's id.
    nonisolated public func showSceneElement(_ id: String) {
        Task {
            await storage.sceneStorage
                .last { scene in
                    let destroy = await scene.destroy
                    return await scene.id == id && !destroy
                }?
                .show() ?? addSceneElement(id)
        }
    }

    /// Add a new scene element with the content of the scene element with a certain id.
    /// - Parameter id: The element's id.
    nonisolated public func addSceneElement(_ id: String) {
        Task {
            await internalAddSceneElement(id)
        }
    }

    /// Add a new scene element with the content of the scene element with a certain id.
    /// - Parameter id: The element's id.
    func internalAddSceneElement(_ id: String) {
        if let element = storage.app?().scene.last(where: { $0.id == id }) {
            let container = element.container(app: self)
            storage.sceneStorage.append(container)
            showSceneElement(id)
        }
    }

    /// Focus the window with a certain id (if supported). Create the window if it doesn't already exist.
    /// - Parameter id: The window's id.
    nonisolated public func showWindow(_ id: String) {
        showSceneElement(id)
    }

    /// Add a new window with the content of the window template with a certain id.
    /// - Parameter id: The window template's id.
    nonisolated public func addWindow(_ id: String) {
        addSceneElement(id)
    }

}
