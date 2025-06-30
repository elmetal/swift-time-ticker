import Foundation

/// 時間配信イベントを表現する構造体
public struct TimeEvent {
    /// イベント発生時の日時
    public let date: Date
    
    /// タイムスタンプ（Unix時間）
    public let timestamp: TimeInterval
    
    /// イニシャライザ
    public init(date: Date) {
        self.date = date
        self.timestamp = date.timeIntervalSince1970
    }
} 