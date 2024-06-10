import Meta
import SampleBackends

struct DemoView: SimpleView {

     var view: Body {
        Backend1.TestWidget()
        testContent
     }

     @ViewBuilder
     var testContent: Body {
        Backend2.TestWidget()
        Backend1.TestWidget()
     }

}

print(DemoView().getDebugTree(parameters: true, type: Backend1.BackendView.self))
print(DemoView().getDebugTree(parameters: true, type: Backend2.BackendView.self))