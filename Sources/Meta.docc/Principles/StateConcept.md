# State

The user interface is treated as a function of its state. Instead of directly modifying the UI, modify its state to update views.

## Reactive Programming

When using _Meta_, not only the structure of the user interface is developed in a declarative way (<doc:DeclarativeDesign>), the updating system is as well.
You define all the information used for processing the user interface in the app's structure or custom view structures.
Whenever information gets updated, the user interface re-renders automatically.

## State

An app is built around data it can read and modify. This data is called state. As an example, if you have a simple counter app, there is one piece of state: the count.

```swift
@main
struct CounterApp: App {

    let id = "io.github.david_swift.CounterApp"
    var app: SomePlatformApp!

    @State private var count = 0 // Initialize state

    var scene: Scene {
        Window("Awesome App") {
            HStack {
                Button(.minus) { count -= 1 } // Modify state
                Text("\(count)") // Get state
                Button(.plus) { count += 1 } // Modify state
            }
        }
    }

}
```

Whenever one of the buttons gets pressed and updates the state variable, the UI elements automatically get updated (see <doc:DeclarativeDesign> for more information about the elements). As this happens for all the state variables (properties of the view marked with ``State``), and because manual synchronization is challenging, the following rule is very important:

> Each state variable creates a new source of truth.

You should have _one_ source of truth for _one_ piece of data. It might help to think about the UI being a function of the state: in the same way as you want to minimize the number of parameters of a function and compute as much as possible, you want to minimize the number of state variables. Therefore, if you want to display double the count, implement the operation while rendering the view:

```swift
Text("\(2 * count)")
```

For more complex operations, computed variables can be helpful.

```swift
@main
struct CounterApp: App {

    let id = "io.github.david_swift.CounterApp"
    var app: SomePlatformApp!

    @State private var count = 0

    var doubleCount: Int {
        2 * count
    }

    var scene: Scene {
        Window("Awesome App") {
            HStack {
                Button(.minus) { count -= 1 }
                Text("\(doubleCount)")
                Button(.plus) { count += 1 }
            }
        }
    }

}
```

## State in Views

State cannot only be defined for an app definition, but also for a view definition.
In order not to violate the "single source of truth" concept, the state should be defined in the least common ancestor of all the views accessing this state.

You can pass state to child views using two different methods.

### Read the State in Child Views

Whenever you want to read, but not modify the state in a child view, use a regular property in the view.

```swift
struct CountView: View {

    var count: Int // The property

    var view: Body {
        Text("\(count)") // Get the property
    }

}

struct ContentView: View {

    @State private var count = 0

    var view: Body {
        CountView(count: count) // Pass state to the child view
    }

}
```

### Read and Modify the State in Child Views

If you want to modify the state in a child view, you need to establish two-way data traffic.
_Meta_ provides the property wrapper ``Binding`` for this.

```swift
struct IncreaseButton: View {

    @Binding var count: Int // The binding property

    var view: Body {
        Button(.plus) {
            count += 1 // Modify the binding
        }
    }

}

struct ContentView: View {

    @State private var count = 0

    var view: Body {
        IncreaseButton(count: $count) // Pass state or a binding as a binding to the child view using the dollar sign ($)
    }

}
```

## Organization

Instead of having many state variables in one view, you can combine them to one value type if sensible.

```swift
struct ContentData {

    var count = 0
    var label = "Hello"

}

struct ContentView: View {

    @State private var data = ContentData()

    var view: Body {
        Button(data.label) { // Directly access properties
            data.count -= 1 // Directly update properties
        }
        IncreaseButton(count: $data.count) // Pass a property as a binding
    }

}
```

### Models

Often when creating complex value types, it is a good idea to provide functions inside of the type manipulating its properties instead of defining them on the views.
Remember to use the `mutating` keyword to enable the mutation.

In rare cases, you want to update a complex value type in the same way from an asynchronous context.
As this is not directly possible with value types, a workaround is needed.
Take a look at the documentation for the ``Model`` for more information,
but remember that this should only be used when needed.

## State in Backends

When creating a backend, you do not have to worry about state. State is fully managed by the _Meta_ package.
More information on how to create a backend can be found in the <doc:CreateBackend> tutorial.
