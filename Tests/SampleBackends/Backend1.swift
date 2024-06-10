import Meta

public enum Backend1 {

    public struct TestWidget: BackendWidget {
    
        public init() { }
    
        public var debugTreeContent: [(String, body: Body)] {
            []
        }
        
        public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
            []
        }
    
        public func container(modifiers: [(AnyView) -> AnyView]) -> ViewStorage {
            print("Init Content")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool) {
            storage.fields["test"] = storage.fields["tests"] as? Int ?? 0 + 1
        }
    
    }
    
    public protocol BackendView: AnyView { }
    
    public protocol BackendWidget: BackendView, Widget { }

}