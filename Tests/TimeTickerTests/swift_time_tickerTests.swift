import Testing
import Foundation
@testable import TimeTicker

@Test("TimeEvent should contain date and timestamp")
func testTimeEventBasicStructure() async throws {
    // Given
    let testDate = Date()
    
    // When
    let timeEvent = TimeEvent(date: testDate)
    
    // Then
    #expect(timeEvent.date == testDate)
    #expect(timeEvent.timestamp == testDate.timeIntervalSince1970)
}

@Test("TimeEvent should provide formatted time string") 
func testTimeEventFormattedTime() async throws {
    // Given
    let testDate = Date(timeIntervalSince1970: 1640995200) // 2022-01-01 00:00:00 UTC
    
    // When
    let timeEvent = TimeEvent(date: testDate)
    
    // Then
    #expect(!timeEvent.formattedTime.isEmpty)
    #expect(timeEvent.formattedTime.contains("2022"))
}

// MARK: - TickInterval Tests

@Test("TickInterval should provide predefined intervals")
func testTickIntervalPredefinedValues() async throws {
    // When & Then
    let secondInterval = TickInterval.seconds(1)
    let millisecondInterval = TickInterval.milliseconds(100)
    let customInterval = TickInterval.custom(0.5)
    
    #expect(secondInterval.timeInterval == 1.0)
    #expect(millisecondInterval.timeInterval == 0.1)
    #expect(customInterval.timeInterval == 0.5)
}

@Test("TickInterval should validate custom intervals")
func testTickIntervalValidation() async throws {
    // When & Then - positive interval should be valid
    let validInterval = TickInterval.custom(0.1)
    #expect(validInterval.timeInterval == 0.1)
    
    // Zero or negative intervals should default to minimum
    let zeroInterval = TickInterval.custom(0)
    #expect(zeroInterval.timeInterval == TickInterval.minimumInterval)
    
    let negativeInterval = TickInterval.custom(-1)
    #expect(negativeInterval.timeInterval == TickInterval.minimumInterval)
}

// MARK: - TimeTicker Tests

@Test("TimeTicker should emit time events at specified intervals")
func testTimeTickerBasicTicking() async throws {
    // Given
    let ticker = TimeTicker(interval: .milliseconds(100))
    var receivedEvents: [TimeEvent] = []
    let expectedCount = 3
    
    // When
    do {
        for try await event in ticker.events().prefix(expectedCount) {
            receivedEvents.append(event)
        }
    } catch {
        throw error
    }
    
    // Then
    #expect(receivedEvents.count == expectedCount)
    
    // Verify that events are recent
    let now = Date()
    for event in receivedEvents {
        let timeDifference = abs(now.timeIntervalSince(event.date))
        #expect(timeDifference < 1.0) // Should be within 1 second
    }
}

@Test("TimeTicker should respect custom intervals")
func testTimeTickerCustomInterval() async throws {
    // Given
    let customInterval = TimeInterval(0.05) // 50ms
    let ticker = TimeTicker(interval: .custom(customInterval))
    let startTime = Date()
    var timestamps: [TimeInterval] = []
    
    // When - collect 2 events to measure interval
    do {
        for try await event in ticker.events().prefix(2) {
            timestamps.append(event.date.timeIntervalSince(startTime))
        }
    } catch {
        throw error
    }
    
    // Then
    #expect(timestamps.count == 2)
    
    // Verify interval timing (with some tolerance for system scheduling)
    if timestamps.count >= 2 {
        let actualInterval = timestamps[1] - timestamps[0]
        let tolerance = customInterval * 0.5 // 50% tolerance
        #expect(actualInterval >= customInterval - tolerance)
        #expect(actualInterval <= customInterval + tolerance)
    }
}

@Test("TimeTicker should be cancellable")
func testTimeTickerCancellation() async throws {
    // Given
    let ticker = TimeTicker(interval: .milliseconds(10))
    var eventCount = 0
    
    // When
    let task = Task {
        do {
            for try await _ in ticker.events().prefix(100) {
                eventCount += 1
                if eventCount >= 2 {
                    break
                }
            }
        } catch {
            // Task was cancelled or other error occurred
        }
    }
    
    // Cancel after short delay
    try await Task.sleep(nanoseconds: 50_000_000) // 50ms
    task.cancel()
    
    // Then
    #expect(eventCount >= 1) // Should have received at least one event
    #expect(eventCount <= 10) // Should not have received too many due to cancellation
}
