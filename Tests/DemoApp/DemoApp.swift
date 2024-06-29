import Foundation
import Meta
import Observation
import SampleBackends

@available(macOS 14, *)
@available(iOS 17, *)
struct DemoView: View {

    @State private var test = TestModel()

    var view: Body {
        Backend1.TestWidget1()
        Backend1.Button(test.test) {
            test.test = "\(Int.random(in: 1...10))"
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

        print(DemoView().getDebugTree(parameters: true, type: backendType, modifiers: []))
        let storage = DemoView().storage(modifiers: [], type: backendType)
        for round in 0...2 {
            print("#\(round)")
            DemoView().updateStorage(storage, modifiers: [], updateProperties: true, type: backendType)
        }

        StateManager.addUpdateHandler { _ in
            DemoView().updateStorage(storage, modifiers: [], updateProperties: false, type: backendType)
        }

        sleep(2)
        DemoView().updateStorage(storage, modifiers: [], updateProperties: true, type: backendType)
    }

}
