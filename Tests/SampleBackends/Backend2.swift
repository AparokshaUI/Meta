import Meta

public enum Backend2 {

    public struct TestWidget2: BackendWidget {
    
        public init() { }
    
        public func container<Storage>(modifiers: [(AnyView) -> AnyView], type: Storage.Type) -> ViewStorage where Storage: AppStorage {
            print("Init test widget 2")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Storage>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: Storage.Type) {
            print("Update test widget 2 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }
    
    }
    
    public struct TestWidget4: BackendWidget {

        public init() { }

        public func container<Storage>(modifiers: [(AnyView) -> AnyView], type: Storage.Type) -> ViewStorage where Storage: AppStorage {
            print("Init test widget 4")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<Storage>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: Storage.Type) {
            print("Update test widget 4 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
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

    public class Backend2App: AppStorage {

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
