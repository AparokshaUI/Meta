//
//  View.swift
//  Meta
//
//  Created by david-swift on 09.06.24.
//

/// A structure conforming to `View` is referred to as a view.
/// It can be part of a body.
///
/// ```swift
/// struct Test: View {
///
///     var view: Body {
///         AnotherView()
///     }
///
/// }
/// ```
/// 
/// Use ``SimpleView`` instead if a view does not have to save state.
///
public protocol View: AnyView {

    /// The view's content.
    @ViewBuilder var view: Body { get }

}

extension View {

    /// The view's content.
    public var viewContent: Body {
        [StateWrapper(content: { view }, state: getState())]
    }

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
