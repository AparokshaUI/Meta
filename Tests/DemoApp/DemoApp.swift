import Foundation
import Meta
import SampleBackends

struct DemoView: View {

    @State private var test = "Label"

     var view: Body {
        Backend1.TestWidget1()
        Backend1.Button(test) {
            test = "\(Int.random(in: 1...10))"
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

struct TestView: SimpleView {

    var view: Body {
        Backend2.TestWidget4()
    }

}

let backendType = Backend1.BackendWidget.self
let modifiers: [(AnyView) -> AnyView] = [
    { $0 as? Backend2.TestWidget2 != nil ? [Backend1.TestWidget1()] : $0 }
]

print(DemoView().getDebugTree(parameters: true, type: backendType, modifiers: modifiers))
let storage = DemoView().storage(modifiers: modifiers, type: backendType)
for round in 0...2 {
    print("#\(round)")
    DemoView().updateStorage(storage, modifiers: modifiers, updateProperties: true, type: backendType)
}

UpdateManager.addUpdateHandler { _ in
    print("#Handler")
    DemoView().updateStorage(storage, modifiers: modifiers, updateProperties: false, type: backendType)
}

sleep(2)
