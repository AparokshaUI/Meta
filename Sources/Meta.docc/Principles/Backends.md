# Backends

Multiple UI frameworks can be used in the same code, but the selection of the framework happens when executing the app. This enables the creation of cross-platform UI frameworks combining several UI frameworks which render always with the same backend.

## Overview

A backend is a Swift package. It is a fully functional UI framework on its own, based on the principles of <doc:StateConcept> and <doc:DeclarativeDesign>.
The backend defines an ``AppStorage`` reference type, which implements a function for running and quitting the app. 
It implements at least one type conforming to ``SceneElement`` that can be added to an app's scene.
Most importantly, a backend provides various widgets.

Widgets are special views conforming to the ``Widget`` protocol. While other types of views combine other views, as one can see in the articles <doc:DeclarativeDesign> and <doc:StateConcept>, widgets call the underlying UI framework in an imperative fashion. When creating a backend, determine the views available in the UI framework and provide a widget abstraction.

Learn how to create a backend under <doc:CreateBackend>.

## Select a Backend for Rendering

To use a backend in an app, set the correct app storage in the definition of the app.
If you want to create a terminal app, use the [TermKitBackend](https://github.com/david-swift/TermKitBackend).

```swift
import TermKitBackend

@main
struct Subtasks: App {

    let id = "io.github.david_swift.Subtasks"
    var app: TermKitApp! // Render using the TermKitBackend

    var scene: Scene {
        Window {
            ContentView()
        }
    }

}
```

## Cross-Platform Apps

Even though the backend is set to the TermKitBackend, you can use any view conforming to ``AnyView`` and any scene conforming to ``SceneElement`` in your definition.
This is enabled by another concept: backends have their own view protocols and their own scene protocol, which conform to ``Widget`` or ``SceneElement``, respectively.
All the concrete UI elements specific to a backend conform to the backend's protocols.
The conformance to the protocol can therefore be used to identify widgets that should be rendered. If you were to define a platform-independent widget, a so-called convenience widget, make it conform to the ``ConvenienceWidget`` protocol instead, so it will always be rendered.

The app storage of the backend contains the scene element protocols (``AppStorage/SceneElementType``) which will be used for rendering scene elements.
Pass the correct view render data type (``ViewRenderData``) containing the widget type as well as the default wrapper widget when interacting with child views of scene elements or views.

## Umbrella Backends

If some combinations of backends are often used, it might be sensible to create an umbrella backend.
An umbrella backend is simply a collection of view and scene element definitions with support for a specific set of platforms.
An alternative to the ``App`` protocol ensures that the right backend is selected on the right platform.
