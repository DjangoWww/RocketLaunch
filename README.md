# RocketLaunch

- ## Description
  Basically using MVVM + RxSwift + Moya + PromiseKit to build this demo app.

  The main file is inside `RocketLaunch/Modules/`, `RocketLaunch/Service/ServerProvider` and `RocketLaunch/Constants/ServerAPI`, with some other files just for extension and other purposes

- ## Requirements
  - Xcode Version 13.1 (13A1030d)
  - Swift Version 5.5 (swiftlang-1300.0.31.1 clang-1300.0.29.1)

- ## Installation Instructions
  Install Xcode Version 13.1 (13A1030d)

  Try `pod install`, and if everything works out, open RocketLaunch.xcworkspace file with Xcode

- ## About test
  You can find it in `RocketLaunchTests.swift`, only added a few test cases since it's just a demo app

  - `LaunchesListVMTests` : for the purposes to test the ViewModel, there's three functions `testInitialState()`, `testReqLaunchesList()` and `testYearSwitch()`. You can find out what can they do by their name and ofc there's some code comment attached

  - `ServerProviderTests` : for the purposes to test the API request, there's only one function `testReqLaunchesList()`. You can find out what can they do by its name and ofc there's some code comment attached

- ## File tree
  Check `Tree.md` file
