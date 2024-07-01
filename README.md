<p align="center">
  <h1 align="center">Meta</h1>
</p>

<p align="center">
  <a href="https://aparokshaui.github.io/meta/">
  Documentation
  </a>
  ·
  <a href="https://github.com/AparokshaUI/Meta">
  GitHub
  </a>
</p>

_Meta_ is a framework allowing the creation of user interface (UI) frameworks in Swift.

## Table of Contents

- [Overview](#overview)
- [Usage](#usage)
- [Thanks](#thanks)

## Overview

_Meta_ follows the following principles:

- It is a **declarative** framework, meaning that instead of writing _how_ to construct a user interface, you write _what_ it looks like.
- The user interface is treated as a function of its **state**. Instead of directly modifying the UI, modify its state to update views.
- Multiple UI frameworks can be used in the same code, but the **selection of the framework** happens when executing the app. This enables the creation of cross-platform UI frameworks combining several UI frameworks rendering always with the same backend.

It knows the following layers of UI:

- An app is the entry point of the executable, containing the windows.
- A scene element is a template for a container holding one or multiple views (e.g. a window).
- A view is a part of the actual UI inside a window, another view or a menu.
- A menu is a list of buttons, other menus, and views. Certain views (such as menu buttons) allow menus to be used.

Detailed information can be found in the [docs](https://aparokshaui.github.io/meta/).

## Usage

_Meta_ can be used for creating UI frameworks in Swift which can then be used to create apps.

Follow those steps if you want to create a UI framework.

1. Open your Swift package in GNOME Builder, Xcode, or any other IDE.
2. Open the `Package.swift` file.
3. Into the `Package` initializer, under `dependencies`, paste:
```swift
.package(url: "https://github.com/AparokshaUI/Meta", from: "0.1.0")   
```

## Thanks

- [DocC](https://github.com/apple/swift-docc) used for the documentation
- [SwiftLint](https://github.com/realm/SwiftLint) for checking whether code style conventions are violated
- The programming language [Swift](https://github.com/swiftlang/swift)
