import Foundation

/// An async sequence that delivers time events at regular intervals.
///
/// `TimeTickerAsyncSequence` implements `AsyncSequence` to provide a stream of
/// `TimeEvent` instances with configurable timing intervals. The sequence continues
/// indefinitely until cancelled or the iteration terminates.
///
/// Use this sequence with Swift's `for await` syntax to receive time events:
///
/// ```swift
/// for try await event in ticker.events() {
///     // Process time event
/// }
/// ```
public struct TimeTickerAsyncSequence: AsyncSequence {
    public typealias Element = TimeEvent
    
    private let interval: TickInterval
    
    init(interval: TickInterval) {
        self.interval = interval
    }
    
    public func makeAsyncIterator() -> TimeTickerAsyncIterator {
        return TimeTickerAsyncIterator(interval: interval)
    }
}

/// An async iterator that generates time events at specified intervals.
///
/// `TimeTickerAsyncIterator` implements `AsyncIteratorProtocol` to provide the
/// iteration logic for `TimeTickerAsyncSequence`. Each call to `next()` waits
/// for the configured interval before yielding a new `TimeEvent`.
///
/// The iterator respects task cancellation and will throw `CancellationError`
/// when the containing task is cancelled.
public struct TimeTickerAsyncIterator: AsyncIteratorProtocol {
    public typealias Element = TimeEvent
    
    private let interval: TickInterval
    
    init(interval: TickInterval) {
        self.interval = interval
    }
    
    /// Returns the next time event in the sequence.
    ///
    /// This method waits for the configured interval using `Task.sleep()`, then
    /// checks for task cancellation before creating and returning a new `TimeEvent`
    /// with the current date and time.
    ///
    /// - Returns: A `TimeEvent` representing the current moment, or `nil` if iteration
    ///   should terminate (though this implementation continues indefinitely).
    /// - Throws: `CancellationError` if the task is cancelled during iteration.
    public mutating func next() async throws -> TimeEvent? {
        let nanoseconds = UInt64(interval.timeInterval * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
        
        try Task.checkCancellation()
        
        return TimeEvent(date: Date())
    }
} 