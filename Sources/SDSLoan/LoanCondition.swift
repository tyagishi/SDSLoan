//
//  LoanCondition.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanCondition: Identifiable {
    public var id = UUID()
    let loanAmount: Decimal
    let ratePerYear: Decimal // 0.01 = 1%
    let numOfPayment: Int // 1 year loan -> 12 times

    var onePaymentAmount: Decimal?

    let frequency: PaymentDateFrequency
    let startDate: Date? // nil = not decided

    public init(id: UUID = UUID(),
                loanAmount: Decimal, ratePerYear: Decimal, numOfPayment: Int,
                onePaymentAmount: Decimal? = nil,
                frequency: PaymentDateFrequency,
                startDate: Date? = nil) {
        self.id = id
        self.loanAmount = loanAmount
        self.ratePerYear = ratePerYear
        self.numOfPayment = numOfPayment
        self.onePaymentAmount = onePaymentAmount
        self.frequency = frequency
        self.startDate = startDate
    }
    
    func calcOnePaymentAmount() -> Decimal {
        let monthlyRate = ratePerYear / 12
        let p = pow(1 + monthlyRate, numOfPayment)
        return loanAmount * monthlyRate * p / (p - 1.0)
    }
    
}

extension Decimal {
    func rounding(_ behavior: NSDecimalNumberHandler) -> Decimal {
        ((self as NSDecimalNumber).rounding(accordingToBehavior: behavior)) as Decimal
    }
}

extension NSDecimalNumberHandler {
    convenience init(roundingMode: NSDecimalNumber.RoundingMode, scale: Int16) {
        self.init(roundingMode: roundingMode, scale: scale,
                  raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
    }
    public static let plain = NSDecimalNumberHandler(roundingMode: .plain, scale: 0)
    public static let up = NSDecimalNumberHandler(roundingMode: .up, scale: 0)
    public static let down = NSDecimalNumberHandler(roundingMode: .down, scale: 0)
    public static let bankers = NSDecimalNumberHandler(roundingMode: .bankers, scale: 0)
}
