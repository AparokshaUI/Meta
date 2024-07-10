import Meta

public enum Backend1 {

    public struct TestWidget1: BackendWidget {

        public init() { }

        public func container<Storage>(modifiers: [(AnyView) -> AnyView], type: Storage.Type) -> ViewStorage where Storage: AppStorage {
            print("Init test widget 1")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Storage>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: Storage.Type) {
            print("Update test widget 1 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }

    }

    public struct TestWidget3: BackendWidget {

        public init() { }

        public func container<Storage>(modifiers: [(AnyView) -> AnyView], type: Storage.Type) -> ViewStorage where Storage: AppStorage {
            print("Init test widget 3")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Storage>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: Storage.Type) {
            print("Update test widget 3 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }

    }

    public struct Button: BackendWidget {

        var label: String
        var action: () -> Void

        public init(_ label: String, action: @escaping () -> Void) {
            self.label = label
            self.action = action
        }

        public func container<Storage>(modifiers: [(any AnyView) -> any AnyView], type: Storage.Type) -> ViewStorage where Storage: AppStorage {
            print("Init button")
            let storage = ViewStorage(nil)
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                (storage.fields["action"] as? () -> Void)?()
            }
            storage.fields["action"] = action
            return storage
        }

        public func update<Storage>(_ storage: ViewStorage, modifiers: [(any AnyView) -> any AnyView], updateProperties: Bool, type: Storage.Type) {
            storage.fields["action"] = action
            if updateProperties {
                print("Update button (label = \(label))")
            } else {
                print("Do not update button (label = \(label))")
            }
        }

    }

    public struct Menu: BackendWidget, MenuElement {

        var label: String
        var content: MenuContent

        public init(_ label: String, @Builder<MenuElement> content: @escaping () -> MenuContent) {
            self.label = label
            self.content = content()
        }

        public func container<RenderableType>(type: RenderableType.Type, fields: [String : Any]) -> RenderableStorage {
            .init(nil)
        }

        public func update<RenderableType>(_ storage: RenderableStorage, updateProperties: Bool, type: RenderableType.Type, fields: [String : Any]) {
            print("Update renderable")
        }

        public func container<Storage>(modifiers: [(any AnyView) -> any AnyView], type: Storage.Type) -> ViewStorage where Storage: AppStorage {
            let storage = ViewStorage(nil)
            storage.renderableContent[.mainContent] = (content as [Renderable]).storages(type: MenuElement.self, fields: [:])
            return storage
        }

        public func update<Storage>(_ storage: ViewStorage, modifiers: [(any AnyView) -> any AnyView], updateProperties: Bool, type: Storage.Type) {
            guard updateProperties, let content = storage.renderableContent[.mainContent] else {
                return
            }
            (self.content as [Renderable]).update(content, updateProperties: updateProperties, type: MenuElement.self, fields: [:])
        }

    }

    public struct Window: BackendSceneElement {

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
                app.storage.sceneStorage.append(container(app: app))
            }
        }

        public func container<Storage>(app: Storage) -> SceneStorage where Storage: AppStorage {
            print("Show \(id)")
            let viewStorage = content.storage(modifiers: [], type: Storage.self)
            return .init(id: id, pointer: nil, content: [.mainContent : [viewStorage]]) {
                print("Make visible")
            }
        }

        public func update<Storage>(_ storage: SceneStorage, app: Storage, updateProperties: Bool) where Storage: AppStorage {
            print("Update \(id)")
            guard let viewStorage = storage.content[.mainContent]?.first else {
                return
            }
            content.updateStorage(viewStorage, modifiers: [], updateProperties: updateProperties, type: Storage.self)
        }

    }

    public struct Wrapper: BackendWidget, Meta.Wrapper {

        var content: Body

        public init(@ViewBuilder content: @escaping () -> Body) {
            self.content = content()
        }

        public func container<Storage>(modifiers: [(any Meta.AnyView) -> any Meta.AnyView], type: Storage.Type) -> Meta.ViewStorage where Storage : Meta.AppStorage {
            let storage = ViewStorage(nil)
            storage.content = [.mainContent: content.storages(modifiers: modifiers, type: type)]
            return storage
        }

        public func update<Storage>(_ storage: Meta.ViewStorage, modifiers: [(any Meta.AnyView) -> any Meta.AnyView], updateProperties: Bool, type: Storage.Type) where Storage : Meta.AppStorage {
            guard let storages = storage.content[.mainContent] else {
                return
            }
            content.update(storages, modifiers: modifiers, updateProperties: updateProperties, type: type)
        }

    }

    public protocol BackendWidget: Widget { }

    public protocol BackendSceneElement: SceneElement { }

    public protocol MenuElement: Renderable { }

    public typealias MenuContent = [MenuElement]

    public class Backend1App: AppStorage {

        public typealias SceneElementType = BackendSceneElement
        public typealias WidgetType = BackendWidget
        public typealias WrapperType = Wrapper

        public var app: () -> any App
        public var storage: StandardAppStorage = .init()

        public required init(id: String, app: @escaping () -> any App) {
            self.app = app
        }

        public func run(setup: @escaping () -> Void) {
            setup()
        }

        public func quit() {
            fatalError("Quit")
        }

    }

}

