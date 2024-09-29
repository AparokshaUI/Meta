//
//  WidgetData.swift
//  Meta
//
//  Created by david-swift on 15.08.24.
//

/// Data passed to widgets when initializing or updating the container.
public struct WidgetData: Sendable {

    /// The view modifiers.
    public var modifiers: [@Sendable (AnyView) -> AnyView] = []
    /// The scene storage of the parent scene element.
    public var sceneStorage: SceneStorage
    /// The app storage of the parent app.
    public var appStorage: any AppStorage
    /// Fields for custom data.
    public var fields: [String: Sendable] = [:]

    /// Modify the data so that there are no modifiers.
    public var noModifiers: Self {
        modify { $0.modifiers = [] }
    }

    /// Initialize widget data.
    /// - Parameters:
    ///     - sceneStorage: The storage of the parent scene element.
    ///     - appStorage: The storage of the parent app.
    public init(sceneStorage: SceneStorage, appStorage: any AppStorage) {
        self.sceneStorage = sceneStorage
        self.appStorage = appStorage
    }

    /// Modify the widget data.
    /// - Parameter action: The modification action.
    /// - Returns: The data.
    public func modify(action: (inout Self) -> Void) -> Self {
        var newSelf = self
        action(&newSelf)
        return newSelf
    }

}
