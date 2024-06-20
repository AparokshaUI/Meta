import Meta
import SampleBackends

struct DemoView: SimpleView {

     var view: Body {
        Backend1.TestWidget1()
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
        []
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
