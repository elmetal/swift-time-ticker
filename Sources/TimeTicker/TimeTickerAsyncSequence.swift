import Foundation

/// AsyncSequenceを実装する時間配信シーケンス
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

/// AsyncIteratorProtocolを実装するイテレータ
public struct TimeTickerAsyncIterator: AsyncIteratorProtocol {
    public typealias Element = TimeEvent
    
    private let interval: TickInterval
    
    init(interval: TickInterval) {
        self.interval = interval
    }
    
    public mutating func next() async throws -> TimeEvent? {
        // 指定された間隔で待機
        let nanoseconds = UInt64(interval.timeInterval * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
        
        // キャンセレーションをチェック
        try Task.checkCancellation()
        
        // 現在時刻のイベントを返す
        return TimeEvent(date: Date())
    }
} 