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
        Backend1.TestWidget1()
     }

}

struct TestView: SimpleView {

    var view: Body {
        []
    }

}

print(DemoView().getDebugTree(parameters: true, type: Backend1.BackendWidget.self))
print(DemoView().getDebugTree(parameters: true, type: Backend2.BackendWidget.self))

let storage = DemoView().storage(modifiers: [], type: Backend1.BackendWidget.self)
for _ in 0...2 {
    DemoView().updateStorage(storage, modifiers: [], updateProperties: true, type: Backend2.BackendWidget.self)
}
