//
//  LoanCalc_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSLoan

final class LoanCalc_Tests: XCTestCase {

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

    func test_paymentDates_matches_twiceAYear_2Year() throws {
        typealias sut = LoanCalc

        let jan1 = Calendar.date(2024, 1, 1)
        let freq = PaymentDateFrequency.twiceAYear(at: 1, 5, .noAdjustment)

        let payDates = sut.paymentDates(start: jan1, num: 4, frequency: freq).map({$0})
        XCTAssertEqual(payDates, [
            Calendar.date(2024, 1, 5),
            Calendar.date(2024, 7, 5),
            Calendar.date(2025, 1, 5),
            Calendar.date(2025, 7, 5),
        ])
    }

    func test_payments_1Year() throws {
        typealias sut = LoanCalc
        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!

        let condition = LoanCondition(loanAmount: 1_000_000, ratePerYear: 0.03, numOfPayment: 24,
                                      frequency: .monthly(at: 5, .noAdjustment), startDate: jan1)

        let results = sut.payments(firstPrincipal: Decimal(40481), condition: condition)
        
        XCTAssertEqual(results.count, 24)
        
        XCTAssertEqual(results[0..<24], [
            LoanPayment(date: Calendar.date(2024, 1, 5), principal: 40481, interest: 2500, balanceAfterThisPayment: 959519),
            LoanPayment(date: Calendar.date(2024, 2, 5), principal: 40583, interest: 2398, balanceAfterThisPayment: 918936),
            LoanPayment(date: Calendar.date(2024, 3, 5), principal: 40684, interest: 2297, balanceAfterThisPayment: 878252),
            LoanPayment(date: Calendar.date(2024, 4, 5), principal: 40786, interest: 2195, balanceAfterThisPayment: 837466),
            LoanPayment(date: Calendar.date(2024, 5, 5), principal: 40888, interest: 2093, balanceAfterThisPayment: 796578),
            LoanPayment(date: Calendar.date(2024, 6, 5), principal: 40990, interest: 1991, balanceAfterThisPayment: 755588),
            LoanPayment(date: Calendar.date(2024, 7, 5), principal: 41093, interest: 1888, balanceAfterThisPayment: 714495),
            LoanPayment(date: Calendar.date(2024, 8, 5), principal: 41195, interest: 1786, balanceAfterThisPayment: 673300),
            LoanPayment(date: Calendar.date(2024, 9, 5), principal: 41298, interest: 1683, balanceAfterThisPayment: 632002),
            LoanPayment(date: Calendar.date(2024,10, 5), principal: 41401, interest: 1580, balanceAfterThisPayment: 590601),
            LoanPayment(date: Calendar.date(2024,11, 5), principal: 41505, interest: 1476, balanceAfterThisPayment: 549096),
            LoanPayment(date: Calendar.date(2024,12, 5), principal: 41609, interest: 1372, balanceAfterThisPayment: 507487),
            LoanPayment(date: Calendar.date(2025, 1, 5), principal: 41713, interest: 1268, balanceAfterThisPayment: 465774),
            LoanPayment(date: Calendar.date(2025, 2, 5), principal: 41817, interest: 1164, balanceAfterThisPayment: 423957),
            LoanPayment(date: Calendar.date(2025, 3, 5), principal: 41922, interest: 1059, balanceAfterThisPayment: 382035),
            LoanPayment(date: Calendar.date(2025, 4, 5), principal: 42026, interest:  955, balanceAfterThisPayment: 340009),
            LoanPayment(date: Calendar.date(2025, 5, 5), principal: 42131, interest:  850, balanceAfterThisPayment: 297878),
            LoanPayment(date: Calendar.date(2025, 6, 5), principal: 42237, interest:  744, balanceAfterThisPayment: 255641),
            LoanPayment(date: Calendar.date(2025, 7, 5), principal: 42342, interest:  639, balanceAfterThisPayment: 213299),
            LoanPayment(date: Calendar.date(2025, 8, 5), principal: 42448, interest:  533, balanceAfterThisPayment: 170851),
            LoanPayment(date: Calendar.date(2025, 9, 5), principal: 42554, interest:  427, balanceAfterThisPayment: 128297),
            LoanPayment(date: Calendar.date(2025,10, 5), principal: 42661, interest:  320, balanceAfterThisPayment:  85636),
            LoanPayment(date: Calendar.date(2025,11, 5), principal: 42767, interest:  214, balanceAfterThisPayment:  42869),
            LoanPayment(date: Calendar.date(2025,12, 5), principal: 42869, interest:  107, balanceAfterThisPayment:      0),
            ])
    }
    
    func test_payments_twiceAYear() throws {
        typealias sut = LoanCalc
        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!

        let condition = LoanCondition(loanAmount: 1_000_000, ratePerYear: 0.03, numOfPayment: 10,
                                      frequency: .twiceAYear(at: 1, 5, .noAdjustment), startDate: jan1)

        let results = sut.payments(firstPrincipal: Decimal(93434), condition: condition)
        
        XCTAssertEqual(results.count, 10)
        print(results)
        
        XCTAssertEqual(results[0..<10], [
            LoanPayment(date: Calendar.date(2024, 1, 5), principal: 93434, interest: 15000, balanceAfterThisPayment: 906566),
            LoanPayment(date: Calendar.date(2024, 7, 5), principal: 94836, interest: 13598, balanceAfterThisPayment: 811730),
            LoanPayment(date: Calendar.date(2025, 1, 5), principal: 96259, interest: 12175, balanceAfterThisPayment: 715471),
            LoanPayment(date: Calendar.date(2025, 7, 5), principal: 97702, interest: 10732, balanceAfterThisPayment: 617769),
            LoanPayment(date: Calendar.date(2026, 1, 5), principal: 99168, interest:  9266, balanceAfterThisPayment: 518601),
            LoanPayment(date: Calendar.date(2026, 7, 5), principal:100655, interest:  7779, balanceAfterThisPayment: 417946),
            LoanPayment(date: Calendar.date(2027, 1, 5), principal:102165, interest:  6269, balanceAfterThisPayment: 315781),
            LoanPayment(date: Calendar.date(2027, 7, 5), principal:103698, interest:  4736, balanceAfterThisPayment: 212083),
            LoanPayment(date: Calendar.date(2028, 1, 5), principal:105253, interest:  3181, balanceAfterThisPayment: 106830),
            LoanPayment(date: Calendar.date(2028, 7, 5), principal:106830, interest:  1602, balanceAfterThisPayment:      0),
        ])
    }
}
