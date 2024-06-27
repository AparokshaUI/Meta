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
    
    public struct TestWidget3: BackendWidget {

        public init() { }

        public var debugTreeContent: [(String, body: Body)] {
            []
        }

        public var debugTreeParameters: [(String, value: CustomStringConvertible)] {
            []
        }

        public func container<WidgetType>(modifiers: [(AnyView) -> AnyView], type: WidgetType.Type) -> ViewStorage {
            print("Init test widget 3")
            let storage = ViewStorage(nil)
            storage.fields["test"] = 0
            return storage
        }

        public func update<WidgetType>(_ storage: ViewStorage, modifiers: [(AnyView) -> AnyView], updateProperties: Bool, type: WidgetType.Type) {
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

        public var debugTreeContent: [(String, body: Body)] {
            []
        }

        public var debugTreeParameters: [(String, value: any CustomStringConvertible)] {
            _ = action
            return [("label", value: label), ("action", value: "() -> Void")]
        }

        public func container<WidgetType>(modifiers: [(any AnyView) -> any AnyView], type: WidgetType.Type) -> ViewStorage {
            print("Init button")
            Task {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                action()
            }
            return .init(nil)
        }

        public func update<WidgetType>(_ storage: ViewStorage, modifiers: [(any AnyView) -> any AnyView], updateProperties: Bool, type: WidgetType.Type) {
            if updateProperties {
                print("Update button (label = \(label))")
            } else {
                print("Do not update button (label = \(label))")
            }
        }

    }

    public protocol BackendWidget: Widget { }

}
