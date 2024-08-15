import Meta

public enum Backend2 {

    public struct TestWidget2: BackendWidget {
    
        public init() { }
    
        public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 2")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) {
            print("Update test widget 2 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }
    
    }
    
    public struct TestWidget4: BackendWidget {

        public init() { }

        public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 4")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) {
            print("Update test widget 4 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }

    }

    public struct Wrapper: BackendWidget, Meta.Wrapper {

        var content: Body

        public init(@ViewBuilder content: @escaping () -> Body) {
            self.content = content()
        }

        public func container<Data>(data: WidgetData, type: Data.Type) -> Meta.ViewStorage where Data: ViewRenderData {
            let storage = ViewStorage(nil)
            storage.content = [.mainContent: content.storages(data: data, type: type)]
            return storage
        }

        public func update<Data>(_ storage: Meta.ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) where Data: ViewRenderData {
            guard let storages = storage.content[.mainContent] else {
                return
            }
            content.update(storages, data: data, updateProperties: updateProperties, type: type)
        }

    }

    public protocol BackendWidget: Widget { }

    public protocol BackendSceneElement: SceneElement { }

    public class Backend2App: AppStorage {

        public typealias SceneElementType = BackendSceneElement

        public var storage: StandardAppStorage = .init()

        public required init(id: String) { }

        public func run(setup: @escaping () -> Void) {
            setup()
        }

        public func quit() {
            fatalError("Quit")
        }

    }

}
