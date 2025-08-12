import Testing
import Foundation
@testable import TimeTicker

@Test("TimeTicker should emit time events at specified intervals")
func testTimeTickerBasicTicking() async throws {
    // Given
    let ticker = TimeTicker(interval: .milliseconds(100))
    var receivedEvents: [TimeEvent] = []
    let expectedCount = 3
    
    // When
    for try await event in ticker.events().prefix(expectedCount) {
        receivedEvents.append(event)
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
    var eventTimes: [Date] = []
    
    // When - collect 3 events to measure intervals between them
    for try await event in ticker.events().prefix(3) {
        eventTimes.append(event.date)
    }
    
    // Then
    #expect(eventTimes.count == 3)
    
    // Verify interval timing between consecutive events
    // Use reasonable tolerance for CI environments and system scheduling variance
    let tolerance = customInterval * 0.6 // 60% tolerance for CI environment stability
    
    // Check interval between first and second event
    let interval1 = eventTimes[1].timeIntervalSince(eventTimes[0])
    #expect(interval1 >= customInterval - tolerance, "First interval \(interval1) should be >= \(customInterval - tolerance)")
    #expect(interval1 <= customInterval + tolerance, "First interval \(interval1) should be <= \(customInterval + tolerance)")
    
    // Check interval between second and third event  
    let interval2 = eventTimes[2].timeIntervalSince(eventTimes[1])
    #expect(interval2 >= customInterval - tolerance, "Second interval \(interval2) should be >= \(customInterval - tolerance)")
    #expect(interval2 <= customInterval + tolerance, "Second interval \(interval2) should be <= \(customInterval + tolerance)")
    
    // Verify consistency between intervals (they should be similar)
    let intervalDifference = abs(interval1 - interval2)
    #expect(intervalDifference <= tolerance, "Interval difference \(intervalDifference) should be <= \(tolerance)")
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