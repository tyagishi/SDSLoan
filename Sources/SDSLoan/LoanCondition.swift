//
//  LoanCondition.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanCondition: Identifiable, Codable, Hashable, Equatable {
    public static func == (lhs: LoanCondition, rhs: LoanCondition) -> Bool {
        lhs.loanAmount == rhs.loanAmount &&
        lhs.ratePerYear == rhs.ratePerYear &&
        lhs.numOfPayment == rhs.numOfPayment &&
        lhs.frequency == rhs.frequency &&
        lhs.startDate == rhs.startDate
    }
    
    public var id = UUID()
    public var loanAmount: Decimal
    public var ratePerYear: Decimal // 0.01 = 1%
    public var numOfPayment: Int // 1 year loan -> 12 times

    public let frequency: PaymentDateFrequency
    public let startDate: Date // not first pay, contract start day
    public let calendar: Calendar

    public init(id: UUID = UUID(),
                loanAmount: Decimal, ratePerYear: Decimal, numOfPayment: Int,
                frequency: PaymentDateFrequency,
                startDate: Date = Date(),
                calendar: Calendar = Calendar.current) {
        self.id = id
        self.loanAmount = loanAmount
        self.ratePerYear = ratePerYear
        self.numOfPayment = numOfPayment
        self.frequency = frequency
        self.startDate = startDate
        self.calendar = calendar
    }
    
    public var onePaymentAmount: Decimal {
        let monthlyRate = ratePerPayment
        let p = pow(1 + monthlyRate, numOfPayment)
        let amount = loanAmount * monthlyRate * p / (p - 1.0)
        return amount.rounding(.down)
    }
    
    public var ratePerPayment: Decimal {
        ratePerYear / 12 * Decimal(frequency.onePaymentMonthValue)
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

extension LoanCondition {
    @MainActor
    public static let example = LoanCondition(loanAmount: 10_000_000, ratePerYear: 0.0315, numOfPayment: 120,
                                              frequency: .monthly(at: 10, .noAdjustment))
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
