import Meta

public enum Backend2 {

    public struct TestWidget2: BackendWidget {
    
        public init() { }
    
        public func container<Data>(data: WidgetData, type: Data.Type) async -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 2")
            let storage = ViewStorage(nil)
            await storage.setField(key: "test", value: 0)
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) async {
            print("Update test widget 2 (#\(await storage.getField(key: "test") ?? ""))")
            await storage.setField(key: "test", value: (storage.getField(key: "test") as? Int ?? 0) + 1)
        }
    
    }
    
    public struct TestWidget4: BackendWidget {

        public init() { }

        public func container<Data>(data: WidgetData, type: Data.Type) async -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 4")
            let storage = ViewStorage(nil)
            await storage.setField(key: "test", value: 0)
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) async {
            print("Update test widget 4 (#\(await storage.getField(key: "test") ?? ""))")
            await storage.setField(key: "test", value: (storage.getField(key: "test") as? Int ?? 0) + 1)
        }

    }

    public struct Wrapper: BackendWidget, Meta.Wrapper {

        var content: Body

        public init(@ViewBuilder content: @escaping () -> Body) {
            self.content = content()
        }

        public func container<Data>(data: WidgetData, type: Data.Type) async -> Meta.ViewStorage where Data: ViewRenderData {
            let storage = ViewStorage(nil)
            await storage.setContent(key: .mainContent, value: content.storages(data: data, type: type))
            return storage
        }

        public func update<Data>(_ storage: Meta.ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) async where Data: ViewRenderData {
            let storages = await storage.getContent(key: .mainContent)
            await content.update(storages, data: data, updateProperties: updateProperties, type: type)
        }

    }

    public protocol BackendWidget: Widget { }

    public protocol BackendSceneElement: SceneElement { }

    public actor Backend2App: AppStorage{

        public typealias SceneElementType = BackendSceneElement

        public var storage: StandardAppStorage = .init()

        public init(id: String) { }

        nonisolated public func run(setup: @escaping () -> Void) {
            setup()
        }

        nonisolated public func quit() {
            fatalError("Quit")
        }

    }

}
