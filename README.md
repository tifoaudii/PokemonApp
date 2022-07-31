## Pokemon App iOS
An iOS application where user can get a list of pokemon cards, search pokemon card, and get detail of pokemon card.

## Dependency
- Use Swift Package Manager
- Kingfisher: To fetch image from server with less of effort

## Project Specification
- Use Xcode 13.4.1
- Use Swift 5

## Architecture
- Use Single Module Application (Monolith)
- For the presentation layer, use ViewController-Interactor-ViewModel
- ViewController has responsibilities to display the UI content and receive user input
- Interactor has responsibilities to communicate with the network infrastructure layer and give the data back to the view using closure
- ViewModel has responsibility to format the raw entity to presentable model
- Separate navigation logic from the feature using simple Flow object

## How to Run
- Clone project
- Wait SPM to resolve the dependency
- Click CMD + R to run the project
- Click CMD + U to run the unit tests

## Notes
- Current test coverage: 77.8%
