# Create a Backend

Learn how to implement a backend.

## Overview

In this tutorial, [TermKitBackend](https://github.com/david-swift/TermKitBackend) will be used as a sample backend to explain the elements of a backend.
General information can be found in the <doc:Backends> article.

## Package Manifest

Set up a new Swift Package (`swift package init`).
Add the _Meta_ package as well as other dependencies if required to the dependencies section in the manifest.

```swift
let package = Package(
    name: "TermKitBackend",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "TermKitBackend",
            targets: ["TermKitBackend"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AparokshaUI/Meta", from: "0.1.0"),
        .package(url: "https://github.com/david-swift/TermKit", branch: "main")
    ],
    targets: [
        .target(
            name: "TermKitBackend",
            dependencies: ["TermKit", "Meta"]
        )
    ]
)
```

## Backend-Specific Protocols

As mentioned in <doc:Backends>, the backend has to define a backend-specific scene element type.
Often, it is sensible to define a widget type for regular views.

```swift
import Meta

public protocol TermKitSceneElement: SceneElement { }
public protocol TermKitWidget: Widget { }
```

## The Wrapper Widget

In this section, the widget type for regular views will be extended so that it can be used for rendering.

With _Meta_, arrays of ``AnyView`` have to be able to be converted into a single widget.
This allows definitions such as the following one:

```swift
Window {
    Label("Hello")
    Label("World")
}
```

Create a widget which arranges the child views next to each other (on most platforms, doing this vertically makes most sense).
It should conform to the platform-specific widget type as well as ``Wrapper``.
Read the comments for general information about creating widgets.

```swift
import Meta
import TermKit

public struct VStack: Wrapper, TermKitWidget {

    var content: Body

    public init(@ViewBuilder content: @escaping () -> Body) { // Use functions and mark them with the result builder to allow the domain-specific language to be used
        self.content = content()
    }

    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage where Data: ViewRenderData {
        let storages = content.storages(data: data, type: type) // Get the storages of child views
        if storages.count == 1 {
            return .init(storages[0].pointer, content: [.mainContent: storages])
        }
        let view = View()
        for (index, storage) in storages.enumerated() {
            if let pointer = storage.pointer as? TermKit.View {
                view.addSubview(pointer)
                if let previous = (storages[safe: index - 1]?.pointer as? TermKit.View) { // The pointer should be a TermKit view
                    pointer.y = .bottom(of: previous)
                }
            }
        }
        return .init(view, content: [.mainContent: storages]) // Save storages of child views in the parent's storage for view updates
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) where Data: ViewRenderData {
        guard let storages = storage.content[.mainContent] else {
            return
        }
        content.update(storages, data: data, updateProperties: updateProperties, type: type) // Update the storages of child views
    }

}

```

### Correct Updating

Note that the type of the ``ViewStorage/pointer`` differs from backend to backend.
It is a reference to the widget in the original UI framework.

In the update method, update  properties of a widget (such as a button's label) only when the `updateProperties` parameter is `true`.
It indicates that a state variable (see <doc:StateConcept>) of an ancestor view has been updated.
If state doesn't change, it is impossible for the UI to change.
However, consider the following exceptions:

- _Always_ update view content (using ``AnyView/updateStorage(_:data:updateProperties:type:)`` or ``Swift/Array/storages(data:type:)``). Child views may contain own state.
- _Always_ update closures (such as the action of a button widget). They may contain reference to state which is updated whenever a view update takes place.
- _Always_ update bindings. As one can see when looking at ``Binding/init(get:set:)``, they contain two closures which, in most cases, contain a reference to state.

### The Render Data Type

Now, define a view render data type for the main views.

```swift
public enum MainViewType: ViewRenderData {

    public typealias WidgetType = TermKitWidget
    public typealias WrapperType = VStack

}
```

It is possible to have multiple view render data types in one backend for different situations.
As an example, you could add another type for menus.

## The App Storage

An app storage object in the app definition determines which backend to use for rendering.
Therefore, it must contain information about the scene element.

Additionally, the function for executing the app is defined on the object, allowing you to put the setup of the UI into the correct context.
The quit funtion should terminate the app.

```swift
@_exported import Meta // Export the Meta package
import TermKit

public class TermKitApp: AppStorage {

    public typealias SceneElementType = TermKitSceneElement

    public var storage: StandardAppStorage = .init()

    public required init(id: String) { }

    public func run(setup: @escaping () -> Void) {
        Application.prepare()
        setup()
        Application.run()
    }

    public func quit() {
        Application.shutdown()
    }

}

```

## Next Steps

Now, you can start implementing scene elements (windows or other "top-level containers"), and views.
Remember following the instructions for correct updating above for all of the UI element types.

If you still have questions, browse code in the [TermKitBackend repository](https://github.com/david-swift/TermKitBackend) or ask a question in the [discussions](https://github.com/AparokshaUI/Meta/discussions). Feedback on the documentation is appreciated!
