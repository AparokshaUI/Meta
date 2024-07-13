# ``Meta``

_Meta_ is a framework allowing the creation of user interface (UI) frameworks in Swift.

## Overview

_Meta_ follows the following principles:

- It is a **declarative** framework, meaning that instead of writing _how_ to construct a user interface, you write _what_ it looks like.
- The user interface is treated as a function of its **state**. Instead of directly modifying the UI, modify its state to update views.
- Multiple UI frameworks can be used in the same code, but the **selection of the framework** happens when executing the app. This enables the creation of cross-platform UI frameworks combining several UI frameworks which render always with the same backend.

It knows the following layers of UI:

- An app is the entry point of the executable, containing the windows.
- A scene element is a template for a container holding one or multiple views (e.g., a window).
- A view is a part of the actual UI inside a window, or another view.

## Topics

### Principles

- <doc:DeclarativeDesign>
- <doc:StateConcept>
- <doc:Backends>

### Tutorials

- <doc:CreateBackend>
- <doc:CreateApp>
