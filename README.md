# TimeTicker

> A modern Swift library for building time-based applications with Swift Concurrency

TimeTicker provides timezone-independent time streams using Swift Concurrency. Built with AsyncSequence, it delivers precise time events through native async/await patterns.

## Requirements

- Swift 6.1+

## Installation

### Swift Package Manager

Add TimeTicker to your project using Swift Package Manager. In your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/elmetal/swift-time-ticker.git", from: "0.0.1")
]
```

Or add it through Xcode by going to File → Add Package Dependencies and entering the repository URL.

## Usage

```swift
import TimeTicker

// Create a ticker that emits events every second
let ticker = TimeTicker(interval: .seconds(1))

// Receive time events using async/await
for try await timeEvent in ticker.events() {
    print("Current time: \(timeEvent.date)")
    print("Unix timestamp: \(timeEvent.timestamp)")
}
```

## License
MIT
