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

        let cal = Calendar(identifier: .gregorian)
        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!

        XCTAssertEqual(sut.paymentDates(start: jan1, num: 12, frequency: .monthly(date: .exact(5)), in: cal), [
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
    
    func test_payments_1Year() throws {
        typealias sut = LoanCalc
        let jan1 = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!

        let condition = LoanCondition(loanAmount: 10_000_000, ratePerYear: 0.1, numOfPayment: 10,
                                      onePaymentAmount: nil, frequency: .monthly(date: .exact(5)), startDate: jan1)
        
        let cal = Calendar(identifier: .gregorian)

        let result = sut.payments(condition: condition,
                                  frequency: .monthly(date: PayDay(5, .noAdjustment)), in: cal)
        
        
//        XCTAssertEqual(sut.payments(condition, frequency: .monthly(date: PayDay(day: 5, adjustment: .noAdjustment)), in: cal), [
//            LoanPayment(date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5))!,
//                        principal: 10, interest: 10, balanceAfterThisPayment: 10)
//            
//            Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month:10, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month:11, day: 5))!,
//            Calendar.current.date(from: DateComponents(year: 2024, month:12, day: 5))!,
//        ])
    }
    
    func test_onePayment() async throws {
        typealias sut = LoanCalc
        
        
//        let interest = sut.calcNextPayment(<#T##restAmount: Decimal##Decimal#>, rate: <#T##Decimal#>, oneAmount: <#T##Decimal#>)
    }

}
