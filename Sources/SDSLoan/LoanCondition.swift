//
//  LoanCondition.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanCondition: Identifiable, Codable {
    public var id = UUID()
    public let title: String
    public let loanAmount: Decimal
    public let ratePerYear: Decimal // 0.01 = 1%
    public let numOfPayment: Int // 1 year loan -> 12 times

    public let frequency: PaymentDateFrequency
    public let startDate: Date // not first pay, contract start day
    public let calendar: Calendar

    public init(id: UUID = UUID(),
                title: String,
                loanAmount: Decimal, ratePerYear: Decimal, numOfPayment: Int,
                frequency: PaymentDateFrequency,
                startDate: Date = Date(),
                calendar: Calendar = Calendar.current) {
        self.id = id
        self.title = title
        self.loanAmount = loanAmount
        self.ratePerYear = ratePerYear
        self.numOfPayment = numOfPayment
        self.frequency = frequency
        self.startDate = startDate
        self.calendar = calendar
    }
    
    public var onePaymentAmount: Decimal {
        let monthlyRate = ratePerYear / 12
        let p = pow(1 + monthlyRate, numOfPayment)
        let amount = loanAmount * monthlyRate * p / (p - 1.0)
        return amount.rounding(.down)
    }
    
    public var ratePerMonth: Decimal {
        ratePerYear / 12
    }
    
    public var periodInYearMonth: (Int, Int) {
        return numOfPayment.quotientAndRemainder(dividingBy: 12)
    }
    
    public enum CalcMethod {
        //case day   // rate/365 * days
        case month // rate/ 12 * months
    }
    
    func calcInterest(lastPay: LoanPayment, nextDate: Date, way: CalcMethod = .month, rounding mode: NSDecimalNumberHandler) -> Decimal {
        guard let length = ((lastPay.date)..<(nextDate)).months(self.calendar) else { fatalError("error in calc") }
        let amount = lastPay.balanceAfterThisPayment * ratePerMonth * Decimal(length)
        return amount.rounding(mode)
    }
}

extension Decimal {
    public func rounding(_ behavior: NSDecimalNumberHandler) -> Decimal {
        ((self as NSDecimalNumber).rounding(accordingToBehavior: behavior)) as Decimal
    }
}

extension NSDecimalNumberHandler {
    public convenience init(roundingMode: NSDecimalNumber.RoundingMode, scale: Int16) {
        self.init(roundingMode: roundingMode, scale: scale,
                  raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
    }
    public static let plain = NSDecimalNumberHandler(roundingMode: .plain, scale: 0)
    public static let up = NSDecimalNumberHandler(roundingMode: .up, scale: 0)
    public static let down = NSDecimalNumberHandler(roundingMode: .down, scale: 0)
    public static let bankers = NSDecimalNumberHandler(roundingMode: .bankers, scale: 0)
}
