import Foundation

/// The time interval between successive time events in a `TimeTicker`.
///
/// `TickInterval` provides convenient ways to specify time intervals using
/// predefined units or custom durations. All intervals are internally converted
/// to `TimeInterval` values and enforce a minimum threshold for system stability.
public enum TickInterval {
    /// An interval specified in whole seconds.
    ///
    /// - Parameter Int: The number of seconds between events.
    case seconds(Int)
    
    /// An interval specified in milliseconds.
    ///
    /// The millisecond value is converted to fractional seconds when used.
    ///
    /// - Parameter Int: The number of milliseconds between events.
    case milliseconds(Int)
    
    /// A custom interval specified as a `TimeInterval`.
    ///
    /// Custom intervals are validated against `minimumInterval` to ensure
    /// system stability and prevent excessive CPU usage.
    ///
    /// - Parameter TimeInterval: The custom duration between events in seconds.
    case custom(TimeInterval)
    
    /// The minimum allowed interval between time events.
    ///
    /// This value represents 1 millisecond (0.001 seconds) and serves as a
    /// safety threshold to prevent system overload from excessively frequent updates.
    public static let minimumInterval: TimeInterval = 0.001
    
    /// The actual time interval in seconds.
    ///
    /// This computed property converts the enum case to a `TimeInterval` value,
    /// applying the minimum interval constraint for custom values.
    ///
    /// For `custom` intervals below the minimum threshold, the value is
    /// automatically clamped to `minimumInterval`.
    public var timeInterval: TimeInterval {
        switch self {
        case .seconds(let value):
            return TimeInterval(value)
        case .milliseconds(let value):
            return TimeInterval(value) / 1000.0
        case .custom(let interval):
            return max(interval, Self.minimumInterval)
        }
    }
} 