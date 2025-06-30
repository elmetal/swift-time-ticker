import Foundation

/// 時間配信の主要クラス
public class TimeTicker {
    private let interval: TickInterval
    
    /// イニシャライザ
    public init(interval: TickInterval) {
        self.interval = interval
    }
    
    /// 時間イベントを配信するAsyncSequenceを返す
    public func events() -> TimeTickerAsyncSequence {
        return TimeTickerAsyncSequence(interval: interval)
    }
} 