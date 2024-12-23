//
//  LoanCondition_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSLoan

final class LoanCondition_Tests: XCTestCase {

    func test_understanding() async throws {
        let sut = Decimal(string: "0.5")!
        
        XCTAssertEqual(sut.rounding(.up), 1)
        XCTAssertEqual(sut.rounding(.down), 0)
        XCTAssertEqual(sut.rounding(.bankers), 0)
    }
    
    
    func test_onePaymentAmount() async throws {
        let sut = LoanCondition(ratePerYear: 0.03,
                                loanAmount: 1_000_000, numOfPayment: 24, frequency: .monthly(at: 5, .noAdjustment))
        let amount = sut.onePaymentAmount
        XCTAssertEqual(amount, 42981)
    }

    func test_onePaymentAmount_twiceAYear() async throws {
        let sut = LoanCondition(ratePerYear: 0.03,
                                loanAmount: 1_000_000, numOfPayment: 10, frequency: .twiceAYearAt(month: 1, 5, .noAdjustment))
        let amount = sut.onePaymentAmount
        XCTAssertEqual(amount, 108434)
    }

    
    func test_calcInterest() async throws {
        let jan1 = Calendar.date(2024, 1, 1)
        let sut = LoanCondition(ratePerYear: 0.03,
                                loanAmount: 1_000_000, numOfPayment: 24, frequency: .monthly(at: 5, .noAdjustment), startDate: jan1)
        let jan5 = Calendar.date(2024, 1, 5)
        let feb5 = Calendar.date(2024, 2, 5)
        let lastPay = LoanPayment(date: jan5, principal: 40481, interest: 2500, balanceAfterThisPayment: 959519)

        let amount = sut.calcInterest(lastPay: lastPay, nextDate: feb5, rounding: .down)
        XCTAssertEqual(amount, 2398)
    }

    func test_calcInterest_halfYear() async throws {
        let jan1 = Calendar.date(2024, 1, 1)
        let sut = LoanCondition(ratePerYear: 0.03,
                                loanAmount: 1_000_000, numOfPayment: 10, frequency: .twiceAYearAt(month: 1, 5, .noAdjustment), startDate: jan1)
        let jan5 = Calendar.date(2024, 1, 5)
        let jul5 = Calendar.date(2024, 7, 5)
        let lastPay = LoanPayment(date: jan5, principal: 93434, interest: 15000, balanceAfterThisPayment: 906566)

        let amount = sut.calcInterest(lastPay: lastPay, nextDate: jul5, rounding: .down)
        XCTAssertEqual(amount, 13598)
    }
    
    func test_calcInteresetPerDays() async throws {
        let jan1 = Calendar.date(2024, 1, 1)
        let sut = LoanCondition(ratePerYear: 0.03,
                                loanAmount: 1_000_000, numOfPayment: 10, frequency: .monthly(at: 5, .noAdjustment), startDate: jan1)
        let jan10 = Calendar.date(2024, 1, 10)

        let amount = sut.calcInteresetPerDays(startDate: jan1, nextDate: jan10, rounding: .down)
        XCTAssertEqual(amount, 739)
    }

    // MARK: bonus
    func test_oneBonusPaymentAmount_twiceAYear() async throws {
        let sut = LoanCondition(ratePerYear: 0.03,
                                loanAmount: 1_000_000, numOfPayment: 12*5, frequency: .twiceAYearAt(month: 1, 10, .noAdjustment))
        
        let amount = sut.onePaymentAmount
        XCTAssertEqual(amount, 25393)
    }
}
