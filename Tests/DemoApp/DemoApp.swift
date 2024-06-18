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

print(DemoView().getDebugTree(parameters: true, type: backendType))
let storage = DemoView().storage(modifiers: [], type: backendType)
for _ in 0...2 {
    DemoView().updateStorage(storage, modifiers: [], updateProperties: true, type: backendType)
}
