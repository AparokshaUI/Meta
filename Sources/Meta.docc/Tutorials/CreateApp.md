# Create an App

Learn how to use a backend for creating your app.

## Find a Backend

To develop an app, you first need to find either a backend or an umbrella backend.
Add it as a dependency to your package manifest.

If there is no backend for the UI framework available, you can create one yourself. Help is available under <doc:CreateBackend>.
If you need a specific combination of platforms, creating an umbrella backend may be a solution. Find more information under <doc:Backends>.

In this tutorial, [TermKitBackend](https://github.com/david-swift/TermKitBackend) will be used as a sample backend.

## Create the User Interface

Start by defining the app structure.

```swift
import TermKitBackend

@main
struct AppName: App {

    let id = "com.example.AppName"
    var app: TermKitApp!

    var scene: Scene {
        Window {
            Label("Hello, world!")
        }
    }

}
```

The `id` property holds what is known as the bundle identifier on Apple platforms and as the Application ID on GNOME: a reverse DNS style identifier.
Replace the type of the `app` property with the app storage type of your backend. Find the type in the backend's documentation - it conforms to ``AppStorage`` and usually has the suffix "App".

Fill `scene` with the UI definition. More information about the UI elements and the organization of the code is available under <doc:DeclarativeDesign>.
What will be relevant is the concept of <doc:StateConcept>.

## App Storage Functions

Certain functions are defined on the app storage (here `TermKitApp`). The following ones may be helpful when developing an app:

- ``AppStorage/addWindow(_:)`` or ``AppStorage/addSceneElement(_:)`` to create and show scene elements (allows multiple instances)
- ``AppStorage/showWindow(_:)`` or ``AppStorage/showSceneElement(_:)`` to show scene elements or create a new one if it does not already exist (allows only one instance)
- ``AppStorage/quit()`` quits the application

## Support Multiple Platforms

To support multiple platforms, import multiple backends into your code.
You can mix up views from every backend, but only the one that is selected via the `app` property will render.
Therefore, it often makes sense to change the type of the `app` property based on the backend:

```swift
import TermKitBackend

@main
struct AppName: App {

    let id = "com.example.AppName"

#if os(macOS)
    var app: MacApp!
#else
    var app: AdwaitaApp!
#endif

    var scene: Scene {
        Window {
            Label("Hello, world!")
        }
    }

}
```

As this can get complicated, especially because the dependencies should be handled based on the platform as well, the preferred way of supporting multiple backends is to write an umbrella backend (more information under <doc:Backends>).
