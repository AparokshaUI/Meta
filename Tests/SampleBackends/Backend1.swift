import Meta

public enum Backend1 {

    public struct TestWidget1: BackendWidget {
    
        public init() { }
    
        public var debugTreeContent: [(String, body: Body)] {
            []
        }

        public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
            []
        }
    
        public func container<WidgetType>(modifiers: [(AnyView) -> AnyView], type: WidgetType.Type) -> ViewStorage {
            print("Init test widget 1")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<WidgetType>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: WidgetType.Type) {
            print("Update test widget 1 (#\(storage.fields["test"] ?? ""))")
            storage.fields["test"] = (storage.fields["test"] as? Int ?? 0) + 1
        }
    
    }
    
    public protocol BackendWidget: Widget { }

}
