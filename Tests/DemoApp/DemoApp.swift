import Foundation
import Meta
import Observation
import SampleBackends

@available(macOS 14, *)
@available(iOS 17, *)
struct DemoView: View {

    @State private var model = TestModel()

    var view: Body {
        Backend1.TestWidget1()
        Backend1.Button(model.test) {
            model.test = "\(Int.random(in: 1...10))"
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

@main
@available(macOS 14, *)
@available(iOS 17, *)
struct DemoApp {

    static func main() {
        let backendType = Backend1.BackendWidget.self

        let storage = DemoView().storage(modifiers: [], type: backendType)
        for round in 0...2 {
            print("#\(round)")
            DemoView().updateStorage(storage, modifiers: [], updateProperties: true, type: backendType)
        }

        StateManager.addUpdateHandler { force in
            print("#*")
            DemoView().updateStorage(storage, modifiers: [], updateProperties: force, type: backendType)
        }

        sleep(2)
    }

}
