# Contributing

Thank you very much for taking the time for contributing to this project. 

## Report a Bug
Just open a new issue on GitHub and describe the bug. It helps if your description is detailed. Thank you very much for your contribution!

## Suggest a New Feature
Just open a new issue on GitHub and describe the idea. Thank you very much for your contribution!

## Pull Requests
I am happy for every pull request, you do not have to follow these guidelines. However, it might help you to understand the project structure and make it easier for me to merge your pull request. Thank you very much for your contribution!

### 1. Fork & Clone this Project
Start by clicking on the `Fork` button at the top of the page. Then, clone this repository to your computer. 

### 2. Open the Project
Open the project folder in GNOME Builder, Xcode or another IDE.

### 3. Understand the Project Structure
- The `README.md` file contains a description of the app or package.
- The `LICENSE.md` contains an MIT license.
- `CONTRIBUTING.md` is this file.
- Directory `Icons` that contains SVG files for the images used in the app and guides.
- `Sources` contains the source code of the project.
	- `Model` contains the project's basis.
		- `Data Flow` contains property wrappers and protocols required for managing the updates of a view.
		- `Extensions` contains all the extensions of types that are not defined in this project.
		- `User Interface` contains protocols and structures that are the basis of presenting content to the user.
	- `View` contains structures that conform to the `AnyView` protocol.
- `Tests` contains a sample application using two sample backends for testing the package.

### 4. Edit the Code
Edit the code. If you add a new type, add documentation in the code.

### 5. Commit to the Fork
Commit and push the fork.

### 6. Pull Request
Open GitHub to submit a pull request. Thank you very much for your contribution!
