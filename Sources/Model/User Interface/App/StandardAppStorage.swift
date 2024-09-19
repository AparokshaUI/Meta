//
//  StandardAppStorage.swift
//  Meta
//
//  Created by david-swift on 02.07.24.
//

/// The app storage protocol.
public struct StandardAppStorage: Sendable {

    /// The scene storage.
    public var sceneStorage: [SceneStorage] = []

    /// The state storage.
    var stateStorage: [String: StateProtocol] = [:]

    /// The scene.
    var app: (@Sendable () -> any App)?

    /// Initialize the standard app storage.
    public init() { }

}
