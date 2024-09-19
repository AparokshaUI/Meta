//
//  StateManager.swift
//  Meta
//
//  Created by david-swift on 21.06.24.
//

import Foundation

/// This type manages view updates.
public actor StateManager {

    /// Whether to block updates in general.
    public static var blockUpdates = false
    /// The application identifier.
    static var appID: String?
    /// The functions handling view updates.
    static var updateHandlers: [@Sendable (Bool) async -> Void] = []

    /// Update all of the views.
    /// - Parameter force: Whether to force all views to update.
    ///
    /// Nothing happens if ``StateManager/blockUpdates`` is true.
    public static func updateViews(force: Bool = false) {
        if !blockUpdates {
            for handler in updateHandlers {
                Task {
                    await handler(force)
                }
            }
        }
    }

    /// Add a handler that is called when the user interface should update.
    /// - Parameter handler: The handler. The parameter defines whether the whole UI should be force updated.
    static func addUpdateHandler(handler: @Sendable @escaping (Bool) async -> Void) {
        updateHandlers.append(handler)
    }

}
