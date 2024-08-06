import Meta

public enum Backend1 {

    public struct TestWidget1: BackendWidget {

        public init() { }

        public func container<Data>(modifiers: [(AnyView) -> AnyView], type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 1")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: Data.Type) {
            print("Update test widget 1 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }

    }

    public struct TestWidget3: BackendWidget {

        public init() { }

        public func container<Data>(modifiers: [(AnyView) -> AnyView], type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            print("Init test widget 3")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: Data.Type) {
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

        public func container<Data>(modifiers: [(any AnyView) -> any AnyView], type: Data.Type) -> ViewStorage where Data: ViewRenderData {
            print("Init button")
            let storage = ViewStorage(nil)
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                (storage.fields["action"] as? () -> Void)?()
            }
            storage.fields["action"] = action
            return storage
        }

        public func update<Data>(_ storage: ViewStorage, modifiers: [(any AnyView) -> any AnyView], updateProperties: Bool, type: Data.Type) {
            storage.fields["action"] = action
            if updateProperties {
                if (storage.previousState as? Self)?.label != label {
                    print("Update button (label = \(label))")
                }
            } else {
                print("Do not update button (label = \(label))")
            }
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
            let viewStorage = content.storage(modifiers: [], type: MainViewRenderData.self)
            return .init(id: id, pointer: nil, content: [.mainContent : [viewStorage]]) {
                print("Make visible")
            }
        }

        public func update<Storage>(_ storage: SceneStorage, app: Storage, updateProperties: Bool) where Storage: AppStorage {
            print("Update \(id)")
            guard let viewStorage = storage.content[.mainContent]?.first else {
                return
            }
            content.updateStorage(viewStorage, modifiers: [], updateProperties: updateProperties, type: MainViewRenderData.self)
        }

    }

    public struct Wrapper: BackendWidget, Meta.Wrapper {

        var content: Body

        public init(@ViewBuilder content: @escaping () -> Body) {
            self.content = content()
        }

        public func container<Data>(modifiers: [(any Meta.AnyView) -> any Meta.AnyView], type: Data.Type) -> Meta.ViewStorage where Data: ViewRenderData {
            let storage = ViewStorage(nil)
            storage.content = [.mainContent: content.storages(modifiers: modifiers, type: type)]
            return storage
        }

        public func update<Data>(_ storage: Meta.ViewStorage, modifiers: [(any Meta.AnyView) -> any Meta.AnyView], updateProperties: Bool, type: Data.Type) where Data: ViewRenderData {
            guard let storages = storage.content[.mainContent] else {
                return
            }
            content.update(storages, modifiers: modifiers, updateProperties: updateProperties, type: type)
        }

    }

    public struct EitherView: BackendWidget, Meta.EitherView {

        public init(_ condition: Bool, view1: () -> Body, else view2: () -> Body) {
        }

        public func container<Data>(modifiers: [(any AnyView) -> any AnyView], type: Data.Type) -> ViewStorage where Data : ViewRenderData {
            .init(nil)
        }

        public func update<Data>(_ storage: ViewStorage, modifiers: [(any AnyView) -> any AnyView], updateProperties: Bool, type: Data.Type) where Data : ViewRenderData {
        }

    }

    public struct MainViewRenderData: ViewRenderData {

        public typealias WidgetType = BackendWidget
        public typealias WrapperType = Wrapper
        public typealias EitherViewType = EitherView

    }

    public protocol BackendWidget: Widget { }

    public protocol BackendSceneElement: SceneElement { }

    public class Backend1App: AppStorage {

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

