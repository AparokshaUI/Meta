import Meta

public enum Backend1 {

    public struct TestWidget1: BackendWidget {

        public init() { }

        public func container<Data>(data: WidgetData, type: Data.Type) async -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 1")
            let storage = ViewStorage(nil)
            await storage.setField(key: "test", value: 0)
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) async {
            print("Update test widget 1 (#\(await storage.getField(key: "test") ?? ""))")
            await storage.setField(key: "test", value: (storage.getField(key: "test") as? Int ?? 0) + 1)
        }

    }

    public struct TestWidget3: BackendWidget {

        public init() { }

        public func container<Data>(data: WidgetData, type: Data.Type) async -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 3")
            let storage = ViewStorage(nil)
            await storage.setField(key: "test", value: 0)
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) async {
            print("Update test widget 3 (#\(await storage.getField(key: "test") ?? ""))")
            await storage.setField(key: "test", value: (storage.getField(key: "test") as? Int ?? 0) + 1)
        }

    }

    public struct Button: BackendWidget {

        @Property(set: { print("Update button (label = \($1))") }, pointer: Any.self)
        var label = ""
        @Property(set: { $2.setField(key: "action", value: $1) }, pointer: Any.self)
        var action: @Sendable () -> Void = { }

        public init(_ label: String, action: @Sendable @escaping () -> Void) {
            self.label = label
            self.action = action
        }
        public func container<Data>(data: WidgetData, type: Data.Type) async -> ViewStorage where Data: ViewRenderData {
            print("Init button")
            let storage = ViewStorage(nil)
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                (await storage.getField(key: "action") as? @Sendable () -> Void)?()
            }
            await storage.setField(key: "action", value: action)
            await storage.setPreviousState(self)
            return storage
        }

    }

    public struct Window: BackendSceneElement, Sendable {

        public var id: String
        var spawn: Int
        var content: Body

        public init(_ id: String, spawn: Int, @ViewBuilder content: () -> Body) {
            self.id = id
            self.spawn = spawn
            self.content = content()
        }

        public func setupInitialContainers<Storage>(app: Storage) where Storage: AppStorage {
            for _ in 0..<spawn {
                Task {
                    await app.appendScene(container(app: app))
                }
            }
        }

        public func container<Storage>(app: Storage) -> SceneStorage where Storage: AppStorage {
            print("Show \(id)")
            let storage = SceneStorage(id: id, pointer: nil) {
                print("Make visible")
            }
            Task {
                let viewStorage = await content.storage(data: .init(sceneStorage: storage, appStorage: app), type: MainViewRenderData.self)
                await storage.setContent(key: .mainContent, value: [viewStorage])
            }
            return storage
        }

        public func update<Storage>(_ storage: SceneStorage, app: Storage, updateProperties: Bool) where Storage: AppStorage {
            Task {
                print("Update \(id)")
                guard let viewStorage = await storage.getContent(key: .mainContent).first else {
                    return
                }
                await content.updateStorage(viewStorage, data: .init(sceneStorage: storage, appStorage: app), updateProperties: updateProperties, type: MainViewRenderData.self)
            }
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

    public struct EitherView: BackendWidget, Meta.EitherView {

        public init(_ condition: Bool, view1: () -> Body, else view2: () -> Body) {
        }

        public func container<Data>(data: WidgetData, type: Data.Type) -> ViewStorage where Data : ViewRenderData {
            .init(nil)
        }

        public func update<Data>(_ storage: ViewStorage, data: WidgetData, updateProperties: Bool, type: Data.Type) where Data : ViewRenderData {
        }

    }

    public struct MainViewRenderData: ViewRenderData {

        public typealias WidgetType = BackendWidget
        public typealias WrapperType = Wrapper
        public typealias EitherViewType = EitherView

    }

    public protocol BackendWidget: Widget { }

    public protocol BackendSceneElement: SceneElement { }

    public actor Backend1App: AppStorage {

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

