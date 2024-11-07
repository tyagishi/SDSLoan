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
        let sut = LoanCondition(loanAmount: 1_000_000, ratePerYear: 0.03, numOfPayment: 240, frequency: .monthly(date: .exact(5)))
        let amount = sut.calcOnePaymentAmount().rounding(.down)
        XCTAssertEqual(amount, 5545)
    }

}
