//
//  Pointer.swift
//  Meta
//
//  Created by david-swift on 10.07.24.
//

/// A sendable pointer type.
public struct Pointer: Sendable {

    /// The pointer's bit pattern.
    var bitPattern: Int

    /// Get the opaque pointer.
    public var opaquePointer: OpaquePointer? {
        get {
            .init(bitPattern: bitPattern)
        }
        set {
            bitPattern = .init(bitPattern: newValue)
        }
    }

    /// Initialize the pointer.
    /// - Parameter pointer: The opaque pointer.
    public init(_ pointer: OpaquePointer?) {
        bitPattern = .init(bitPattern: pointer)
    }

}
