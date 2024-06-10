// swift-tools-version: 5.8
//
//  Package.swift
//  Meta
//
//  Created by david-swift on 26.05.24.
//

import PackageDescription

/// The Meta package is the foundation of the Aparoksha project.
let package = Package(
    name: "Meta",
    products: [
        .library(
            name: "Meta",
            targets: ["Meta"]
        )
    ],
    targets: [
        .target(
            name: "Meta",
            path: "Sources"
        ),
        .target(
            name: "SampleBackends",
            dependencies: ["Meta"],
            path: "Tests/SampleBackends"
        ),
        .executableTarget(
            name: "DemoApp",
            dependencies: ["SampleBackends"],
            path: "Tests/DemoApp"
        )
    ]
)
