//
//  SceneElement.swift
//  Meta
//
//  Created by david-swift on 30.06.24.
//

/// A structure conforming to `SceneElement` can be added to an app's `scene` property.
public protocol SceneElement {

    /// The window type's identifier.
    var id: String { get }
    /// Set up the initial scene storages.
    /// - Parameter app: The app storage.
    func setupInitialContainers<Storage>(app: Storage) where Storage: AppStorage
    /// The scene storage.
    /// - Parameter app: The app storage.
    func container<Storage>(app: Storage) -> SceneStorage where Storage: AppStorage
    /// Update the stored content.
    /// - Parameters:
    ///     - storage: The storage to update.
    ///     - app: The app storage.
    ///     - updateProperties: Whether to update the view's properties.
    func update<Storage>(_ storage: SceneStorage, app: Storage, updateProperties: Bool) where Storage: AppStorage

}

/// `Scene` is an array of scene elements.
public typealias Scene = [any SceneElement]
