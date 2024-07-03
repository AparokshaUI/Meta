import Foundation
import Meta
import Observation
import SampleBackends

@main
@available(macOS 14, *)
@available(iOS 17, *)
struct TestExecutable {

    public static func main() {
        DemoApp.main()
        sleep(2)
    }

}

@available(macOS 14, *)
@available(iOS 17, *)
struct DemoApp: App {

    let id = "io.github.AparokshaUI.DemoApp"
    // #if os(...)
    var app: Backend1.Backend1App!
    // #else
    // var app: Backend2.Backend2App!
    // #endif

    var scene: Scene {
        Backend1.Window("main", spawn: 1) {
            DemoView(app: app)
        }
    }

}

@available(macOS 14, *)
@available(iOS 17, *)
struct DemoView: View {

    @State private var model = TestModel()
    var app: any AppStorage

    var view: Body {
        Backend1.TestWidget1()
        Backend1.Button(model.test) {
            model.test = "\(Int.random(in: 1...10))"
            app.addSceneElement("main")
        }
        TestView()
        testContent
     }

     @ViewBuilder
     var testContent: Body {
        Backend2.TestWidget2()
        Backend1.TestWidget3()
     }

}

struct TestView: View {

    @State private var test = "Label"

    var view: Body {
        Backend2.TestWidget4()
        Backend1.Button(test) {
            Task {
                try await Task.sleep(nanoseconds: 100_000_000)
                test = "\(Int.random(in: 1...10))"
            }
        }
        Backend1.Menu("Hi") {
            Backend1.Menu("World") {
            }
        }
    }

}

@available(macOS 14, *)
@available(iOS 17, *)
@Observable
class TestModel {

    var test = "Label"

}

