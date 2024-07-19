# Declarative Design

_Meta_ is a declarative framework, meaning that instead of writing _how_ to construct a user interface, you write _what_ it looks like.

## Declarative Programming

When programming in an imperative style, you write a series of commands that will be executed in order to achieve a desired result. As an example, you could define an array in Swift in the following way:

```swift
var array: [Int] = .init()

array.append(5)
array.append(10)
array.append(2)
array.append(3)

// array: [5, 10, 2, 3]
```

If you prefer a more declarative approach, the same result can be achieved by instructing the compiler directly what result to achieve:

```swift
let array = [5, 10, 2, 3]

// array: [5, 10, 2, 3]
```

The comparison between the two solutions shows the most important properties of a more imperative and a more declarative programming style.

| Imperative                                                 | Declarative                                       |
|------------------------------------------------------------|---------------------------------------------------|
| Better visible _how_ the result is achieved (control flow) | Not directly visible how the result is achieved   |
| Result must be mentally constructed based on the commands  | Better visible _what_ the result is (readability) |

Higher readability leads to code that is easier to understand, maintain, and extend. However, declarative code can be less performant as it has to be translated into imperative code.

## Declarative Programming and User Interfaces

User interfaces are often constructed in a quite declarative way. This is enabled by domain-specific languages (which can be used for the definition of the UI only), such as:

- HTML for web pages
- [XAML](https://learn.microsoft.com/en/windows/apps/winui/winui3/desktop-winui3-app-with-basic-interop) for Windows apps
- [JetPack Compose](https://developer.android.com/develop/ui/compose) for Android apps
- [Blueprint](https://jwestman.pages.gitlab.gnome.org/blueprint-compiler/) for GNOME apps
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) for Apple platforms

Swift is a general-purpose language, allowing the definition of simple domain-specific "languages" within the programming language, with a feature called [result builders](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/#Result-Builders). Result builders are used in SwiftUI as well as in the _Meta_ package to create a language that allows the declarative declaration of UIs.

As an example, you could write an app using [TermKit](https://github.com/migueldeicaza/TermKit) imperatively in the following way:

```swift
let win = Window("Window")
win.fill()

let label = Label("Label")

let button = Button("Button") {
    print("Button clicked")
}

win.addSubview(label)
win.addSubview(button)

button.y = .bottom(of: label)
```

When you create a _backend_ for terminal UIs, you can use the imperative [TermKit](https://github.com/migueldeicaza/TermKit) package in combination with the declarative _Meta_ package to create the following domain-specfic language (this creates the same UI as the code above, also calling the same commands after the "translation" to imperative code):

```swift
Window {
    Label("Label")
    Button("Button") {
        print("Button clicked")
    }
}
```

## Elements of the User Interface

_Meta_ knows different levels of UI. The app is the entry point of the executable. It contains multiple scene elements (e.g., windows on desktop systems, but can also be, e.g., menu bars - simply anything "top-level"), which may contain other scene elements, or views.
All of those layers, except for the app layer, are defined using their own domain-specific language.

The following code shows all of the available levels of UI for a typical desktop _backend_ (but all the elements are backend-specific):

```swift
@main
struct AwesomeApp: App { // The app (no DSL)

    let id = "io.github.david_swift.AwesomeApp"
    var app: GenericDesktopApp!

    var scene: Scene { // The scene DSL
        Window("Awesome App") { // The view DSL
            ContentView()
                .padding(10)
            Menu { // The view DSL
                Button("Hello") { print("Hello") }
                Button("World") { print("World") }
            }
        }
    }

}
```

A domain-specific language in _Meta_ consists of the following definitions:

- A result builder translates the domain-specific language into an array (``ViewBuilder`` for views, ``SceneBuilder`` for scenes).
- A protocol for elements of the domain (``AnyView`` for views, ``SceneElement`` for scenes). When constructing or updating a user interface, functions required by this protocol will be called. The array is "translated" into the actual UI.
- A storage object persists between updates and saves data concerning a UI element (``ViewStorage`` for views, ``SceneStorage`` for scenes). This is required as the UI elements' definitions in the DSL are re-rendered with each update.

When creating a backend, you define platform-specific UI elements conforming to the protocol for this type of UI element and manage their "translation" into imperative code using the storage object.

## Split Declarative Definitions

There are two ways to split complex definitions using the DSL, for improving the readability or for reusing components.

First, it is possible to create additional computed variables (such as `scene` above) holding a DSL, and reference them in other DSLs.

```swift
@main
struct AwesomeApp: App {

    let id = "io.github.david_swift.AwesomeApp"
    var app: GenericDesktopApp!

    var scene: Scene {
        MenuBar {
            MainMenu()
        }
        windows
    }

    @SceneBuilder // Use the builder for the specific element type, see the list above
    var windows: Scene {
        Window("Awesome App") {
            ContentView()
        }
        Window("Extensions", spawn: 0) {
            ExtensionsView()
        }
    }

}
```

Second, you can define custom UI elements (e.g. views such as `ContentView`).

```swift
struct ContentView: View {

    var view: Body {
        Label("Hello, world!")
        Button("More Information") {
            print("Hello, world!")
        }
    }

}
```

This technique is used by _umbrella backends_ in order to provide UI elements that render on multiple platforms (more information under <doc:Backends>),
and can be used in combination with the <doc:StateConcept> system to manage the information displayed in parts of the UI.
