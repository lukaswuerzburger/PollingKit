<p align="center">
    <img src="https://raw.githubusercontent.com/lukaswuerzburger/PollingKit/develop/readme-images/logo.png" alt="PollingKit" title="PollingKit" width="128"  height="128"/><br/>
    <b>PollingKit</b><br/>
    <br/>
    <img src="https://img.shields.io/badge/Swift-5-orange" alt="Swift Version" title="Swift Version"/>
    <a href="https://travis-ci.org/lukaswuerzburger/PollingKit"><img src="https://travis-ci.org/lukaswuerzburger/PollingKit.svg?branch=develop" alt="Build Status" title="Build Status"/></a>
    <a href="https://cocoapods.org/pods/PollingKit"><img src="https://img.shields.io/cocoapods/v/PollingKit.svg?style=flat-square" alt="CocoaPods Compatible" title="CocoaPods Compatible"/></a>
    <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="License MIT" title="License MIT"/>
</p>


## Contents

- ✍️ [Description](#%EF%B8%8F-description)
- 🖥 [Example](#-example)
- 🎟 [Demo](#-demo)
- 💻 [How to use](#-how-to-use)
- ⚠️ [Requirements](#%EF%B8%8F-requirements)
- 💪 [Contribute](#-contribute)

## ✍️ Description

The `PollingController` does the timed long-term polling for you and takes care that only one async operation is open at a time. If the async operation takes more time than the timer interval, it waits until the callback is invoked to continue.

## 🖥 Example

```swift
import PollingKit
```

```swift
let pollingController = PollingController(preferredInterval: 5) { callback in

    // Imagine an API call being made here.
    loadSomethingAsynchronously() {
        callback()
    }
}
```

## 🎟 Demo

This demo shows how the `PollingController` switches states.

<img src="https://raw.githubusercontent.com/lukaswuerzburger/PollingKit/develop/readme-images/demo.gif" alt="PollingKit Demo" title="PollingKit Demo" width="320"/>

You can find this demo app in this repository.

## 💻 How to use

**Cocoapods**:  
`PollingKit` is available on Cocoapods. Just put following line in your `Podfile`:
```ruby
pod 'PollingKit'
```

**Swift Package Manager**:  
Add the following to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/lukaswuerzburger/PollingKit.git", from: "2.0.0")
]
```

## ⚠️ Requirements

- Swift 5+
- iOS 10+
- Xcode 13+

## 💪 Contribute

Issues and pull requests are welcome.
