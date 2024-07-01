import Foundation
import Meta
import Observation
import SampleBackends

@main
struct TestExecutable {

    public static func main() {
        DemoApp.main()
        sleep(2)
    }

}

@available(macOS 14, *)
@available(iOS 17, *)
struct DemoApp: App {

    typealias Storage = Backend1.Backend1App
    let id = "io.github.AparokshaUI.DemoApp"
    var app: Backend1.Backend1App!

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
    var app: Backend1.Backend1App

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
    }

}

@available(macOS 14, *)
@available(iOS 17, *)
@Observable
class TestModel {

    var test = "Label"

}

