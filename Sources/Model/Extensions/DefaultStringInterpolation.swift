//
//  DefaultStringInterpolation.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//
//  Thanks to Eneko Alonso, Pyry Jahkola, cukr for the comments in this Swift forum discussion:
//  "Multi-line string nested indentation with interpolation"
//  https://forums.swift.org/t/multi-line-string-nested-indentation-with-interpolation/36933
//

extension DefaultStringInterpolation {

    /// Preserve the indentation in a multi line string.
    /// - Parameter string: The string.
    ///
    /// Use it the following way:
    /// """
    /// Hello
    ///     \(indented: "World\n Test")
    /// """
    public mutating func appendInterpolation(indented string: String) {
        // swiftlint:disable compiler_protocol_init
        let indent = String(stringInterpolation: self).reversed().prefix { " \t".contains($0) }
        // swiftlint:enable compiler_protocol_init
        if indent.isEmpty {
            appendInterpolation(string)
        } else {
            appendLiteral(
                string.split(separator: "\n", omittingEmptySubsequences: false).joined(separator: "\n" + indent)
            )
        }
    }

}
