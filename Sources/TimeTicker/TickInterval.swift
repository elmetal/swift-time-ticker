import Foundation

/// 時間配信の間隔を表現する列挙型
public enum TickInterval {
    /// 秒単位での間隔
    case seconds(Int)
    /// ミリ秒単位での間隔
    case milliseconds(Int)
    /// カスタム間隔
    case custom(TimeInterval)
    
    /// 最小許可間隔（1ミリ秒）
    public static let minimumInterval: TimeInterval = 0.001
    
    /// 実際の時間間隔を取得
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