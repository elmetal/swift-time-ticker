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