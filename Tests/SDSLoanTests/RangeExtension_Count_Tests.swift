//
//  RangeExtension_Count_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSLoan

final class RangeExtension_Count_Tests: XCTestCase {

    func test_days() throws {
        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let jan3 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!
        let jan18 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 18))!
        let dec31 = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!

        XCTAssertEqual((jan1..<dec31).days(Calendar.current), 365) // 2024 is leap year
        XCTAssertEqual((jan3..<jan18).days(Calendar.current), 15)
    }

    func test_months() throws {
        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let jan3 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!
        let jan18 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 18))!
        let dec31 = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 31))!

        XCTAssertEqual((jan1..<dec31).months(Calendar.current), 11)
        XCTAssertEqual((jan3..<jan18).months(Calendar.current), 0)
    }

    func test_months_beyondBoundary() throws {
        let jan3 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!
        let feb2 = Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2))!
        let feb2PM11 = Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2, hour: 23))!
        let feb3 = Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 3))!

        XCTAssertEqual((jan3..<feb2).months(Calendar.current), 0)
        XCTAssertEqual((jan3..<feb2PM11).months(Calendar.current), 0)
        XCTAssertEqual((jan3..<feb3).months(Calendar.current), 1)
    }

    
}
