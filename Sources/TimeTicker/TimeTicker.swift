import Foundation

/// A time ticker that provides continuous time event streaming using Swift Concurrency.
///
/// `TimeTicker` delivers timezone-independent time events through an `AsyncSequence`,
/// enabling responsive time-based applications with configurable intervals.
///
/// Use `TimeTicker` to create digital clocks, periodic timers, or any application
/// that requires regular time updates with Swift's native async/await patterns.
public class TimeTicker {
    private let interval: TickInterval
    
    /// Creates a new time ticker with the specified interval.
    /// 
    /// - Parameter interval: The time interval between successive time events.
    public init(interval: TickInterval) {
        self.interval = interval
    }
    
    /// Returns an async sequence that delivers continuous time events.
    ///
    /// The returned sequence produces `TimeEvent` instances at the specified interval
    /// until the async iteration is cancelled or terminated.
    ///
    /// - Returns: An `AsyncSequence` that yields `TimeEvent` instances.
    ///
    /// - Note: Each iteration waits for the configured interval before yielding
    ///   the next time event. The sequence respects task cancellation.
    public func events() -> TimeTickerAsyncSequence {
        return TimeTickerAsyncSequence(interval: interval)
    }
} 