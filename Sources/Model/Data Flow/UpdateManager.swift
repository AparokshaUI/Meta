//
//  UpdateManager.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

/// This type manages view updates.
public enum UpdateManager {

    /// Whether to block updates in general.
    public static var blockUpdates = false
    /// The functions handling view updates.
    static var updateHandlers: [(Bool) -> Void] = []

    /// Update all of the views.
    /// - Parameter force: Whether to force all views to update.
    ///
    /// Nothing happens if ``UpdateManager/blockUpdates`` is true.
    static func updateViews(force: Bool = false) {
        if !blockUpdates {
            for handler in updateHandlers {
                handler(force)
            }
        }
    }

    /// Add a handler that is called when the user interface should update.
    /// - Parameter handler: The handler. The parameter defines whether the whole UI should be force updated.
    static func addUpdateHandler(handler: @escaping (Bool) -> Void) {
        updateHandlers.append(handler)
    }

}
