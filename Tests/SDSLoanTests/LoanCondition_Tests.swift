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
        let sut = LoanCondition(loanAmount: 1_000_000, ratePerYear: 0.03, numOfPayment: 24, frequency: .monthly(date: .exact(5)))
        let amount = sut.onePaymentAmount
        XCTAssertEqual(amount, 42981)
    }
    
    func test_calcInterest() async throws {
        let sut = LoanCondition(loanAmount: 1_000_000, ratePerYear: 0.03, numOfPayment: 24, frequency: .monthly(date: .exact(5)))
        let jan5 = Calendar.date(2024, 1, 5)
        let feb5 = Calendar.date(2024, 2, 5)
        let lastPay = LoanPayment(date: jan5, principal: 40481, interest: 2500, balanceAfterThisPayment: 959519)

        let amount = sut.calcInterest(lastPay: lastPay, nextDate: feb5, rounding: .down)
        XCTAssertEqual(amount, 2398)
    }

}
