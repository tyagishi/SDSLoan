//
//  LoanCalc_paymentDates_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/11
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSLoan

final class LoanCalc_paymentDates_Tests: XCTestCase {

    func test_paymentDates_1Year() throws {
        typealias sut = LoanCalc

        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!

        XCTAssertEqual(sut.paymentDates(start: jan1, num: 12, frequency: .monthly(at: 5, .noAdjustment)), [
            Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month:10, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month:11, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month:12, day: 5))!,
        ])
    }
    
    func test_paymentDates_matches_1Year() throws {
        typealias sut = LoanCalc

        let jan1 = Calendar.date(2024, 1, 1)
        let freq = PaymentDateFrequency.monthly(at: 5, .noAdjustment)

        XCTAssertEqual(sut.paymentDates(start: jan1, num: 12, frequency: freq), [
            Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month:10, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month:11, day: 5))!,
            Calendar.current.date(from: DateComponents(year: 2024, month:12, day: 5))!,
        ])
    }
    
    func test_paymentDates_twiceAYear() throws {
        typealias sut = LoanCalc

        let jan1 = Calendar.date(2024, 1, 1)
        let freq = PaymentDateFrequency.twiceAYearAt(month: 1, 10, .noAdjustment)

        XCTAssertEqual(sut.paymentDates(start: jan1, num: 12, frequency: freq), [
            Calendar.date(2024, 1, 10),
            Calendar.date(2024, 7, 10),
            Calendar.date(2025, 1, 10),
            Calendar.date(2025, 7, 10),
            Calendar.date(2026, 1, 10),
            Calendar.date(2026, 7, 10),
            Calendar.date(2027, 1, 10),
            Calendar.date(2027, 7, 10),
            Calendar.date(2028, 1, 10),
            Calendar.date(2028, 7, 10),
            Calendar.date(2029, 1, 10),
            Calendar.date(2029, 7, 10),
        ])
    }

    func test_paymentDates_matches_twiceAYear_2Year() throws {
        typealias sut = LoanCalc

        let jan1 = Calendar.date(2024, 1, 1)
        let freq = PaymentDateFrequency.twiceAYearAt(month: 1, 5, .noAdjustment)

        let payDates = sut.paymentDates(start: jan1, num: 4, frequency: freq).map({$0})
        XCTAssertEqual(payDates, [
            Calendar.date(2024, 1, 5),
            Calendar.date(2024, 7, 5),
            Calendar.date(2025, 1, 5),
            Calendar.date(2025, 7, 5),
        ])
    }
    // currently payments more than once in month is not supported
//    func test_paymentDates_matches_twiceAMonth_1Year() throws {
//        typealias sut = LoanCalc
//
//        let jan1 = Calendar.date(2024, 1, 1)
//        let match1 = DateComponents(day: 5, hour: 0, minute: 0, second: 0)
//        let match2 = DateComponents(day: 15, hour: 0, minute: 0, second: 0)
//        let freq = PaymentDateFrequency(matchComponent: [match1, match2], adjustment: .noAdjustment, ratio: 0.5)
//
//        let payDates = sut.paymentDates(start: jan1, num: 12, frequency: freq).map({$0})
//        XCTAssertEqual(payDates, [
//            Calendar.date(2024, 1, 5),
//            Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 15))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 15))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 15))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 15))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 15))!,
//        ])
//    }
}
