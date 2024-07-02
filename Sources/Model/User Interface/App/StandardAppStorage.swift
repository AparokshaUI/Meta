//
//  StandardAppStorage.swift
//  Meta
//
//  Created by david-swift on 02.07.24.
//

/// The app storage protocol.
public struct StandardAppStorage {

    /// The scene storage.
    public var sceneStorage: [SceneStorage] = []

    /// The state storage.
    var stateStorage: [String: StateProtocol] = [:]

    /// Initialize the standard app storage.
    public init() { }

}
