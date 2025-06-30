import Foundation

/// 時間配信イベントを表現する構造体
public struct TimeEvent {
    /// イベント発生時の日時
    public let date: Date
    
    /// タイムスタンプ（Unix時間）
    public let timestamp: TimeInterval
    
    /// フォーマットされた時間文字列
    public let formattedTime: String
    
    /// イニシャライザ
    public init(date: Date) {
        self.date = date
        self.timestamp = date.timeIntervalSince1970
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.formattedTime = formatter.string(from: date)
    }
} 