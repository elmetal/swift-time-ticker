import Foundation

/// A time event that represents a point in time with both date and timestamp representations.
///
/// `TimeEvent` provides timezone-independent time data through two complementary formats:
/// a Swift `Date` object for date operations and a Unix timestamp for numeric calculations.
///
/// Time events are immutable value types that maintain consistency between their
/// date and timestamp representations.
public struct TimeEvent {
    /// The date and time when this event occurred.
    ///
    /// This property provides access to Swift's `Date` type for calendar operations,
    /// formatting, and date arithmetic.
    public let date: Date
    
    /// The Unix timestamp representing the time since January 1, 1970, UTC.
    ///
    /// This property contains the equivalent time as `date` expressed as seconds
    /// since the Unix epoch, useful for numeric calculations and serialization.
    public let timestamp: TimeInterval
    
    /// Creates a time event for the specified date.
    ///
    /// The initializer automatically calculates the corresponding Unix timestamp
    /// to maintain consistency between the date and timestamp representations.
    ///
    /// - Parameter date: The date and time for this event.
    public init(date: Date) {
        self.date = date
        self.timestamp = date.timeIntervalSince1970
    }
} 