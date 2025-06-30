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

 