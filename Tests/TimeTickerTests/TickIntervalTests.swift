import Testing
import Foundation
@testable import TimeTicker

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