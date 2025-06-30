// The Swift Programming Language
// https://docs.swift.org/swift-book

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
