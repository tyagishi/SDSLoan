//
//  CalendarExtension_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSLoan

final class CalendarExtension_Tests: XCTestCase {
    func test_adjustDate_sunday() async throws {
        let sut = Calendar(identifier: .gregorian)
        
        let nov17_2024_Sun = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 17))!
        let nov15_2024_Fri = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 15))!
        let nov18_2024_Mon = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 18))!
        
        XCTAssertEqual(sut.adjustDate(nov17_2024_Sun, adjust: .noAdjustment), nov17_2024_Sun)
        XCTAssertEqual(sut.adjustDate(nov17_2024_Sun, adjust: .nextWorkingDay), nov18_2024_Mon)
        XCTAssertEqual(sut.adjustDate(nov17_2024_Sun, adjust: .prevWorkingDay), nov15_2024_Fri)
    }
    
    func test_adjustDate_saturday() async throws {
        let sut = Calendar(identifier: .gregorian)

        let nov16_2024_Sat = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 16))!
        let nov15_2024_Fri = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 15))!
        let nov18_2024_Mon = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 18))!
        
        XCTAssertEqual(sut.adjustDate(nov16_2024_Sat, adjust: .noAdjustment), nov16_2024_Sat)
        XCTAssertEqual(sut.adjustDate(nov16_2024_Sat, adjust: .nextWorkingDay), nov18_2024_Mon)
        XCTAssertEqual(sut.adjustDate(nov16_2024_Sat, adjust: .prevWorkingDay), nov15_2024_Fri)
    }
    
    func test_adjustDate_tuesday() async throws {
        let sut = Calendar(identifier: .gregorian)

        let nov12_2024_Tue = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 12))!
        
        XCTAssertEqual(sut.adjustDate(nov12_2024_Tue, adjust: .noAdjustment), nov12_2024_Tue)
        XCTAssertEqual(sut.adjustDate(nov12_2024_Tue, adjust: .nextWorkingDay), nov12_2024_Tue)
        XCTAssertEqual(sut.adjustDate(nov12_2024_Tue, adjust: .prevWorkingDay), nov12_2024_Tue)
    }
}
