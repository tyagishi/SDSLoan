//
//  LoanCondition.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanCondition: Identifiable, Codable, Hashable, Equatable, Sendable {
    public static func == (lhs: LoanCondition, rhs: LoanCondition) -> Bool {
        lhs.loanAmount == rhs.loanAmount &&
        lhs.ratePerYear == rhs.ratePerYear &&
        lhs.numOfPayment == rhs.numOfPayment &&
        lhs.frequency == rhs.frequency &&
        lhs.startDate == rhs.startDate
    }
    
    public var id = UUID()
    public var startDate: Date // not first pay, contract start day
    public var ratePerYear: Decimal // 0.01 = 1%

    public var loanAmount: Decimal
    public var numOfPayment: Int // 1 year loan -> 12 times
    public var frequency: PaymentDateFrequency

    public var bonusLoanAmount: Decimal?
    public var bonusFrequency: PaymentDateFrequency?

    public let calendar: Calendar

    public init(id: UUID = UUID(),
                ratePerYear: Decimal,
                loanAmount: Decimal,
                numOfPayment: Int,
                frequency: PaymentDateFrequency,
                bonusLoanAmount: Decimal? = nil,
                bonusFrequency: PaymentDateFrequency? = nil,
                startDate: Date = Date(),
                calendar: Calendar = Calendar.current) {
        self.id = id
        self.ratePerYear = ratePerYear
        self.loanAmount = loanAmount
        self.numOfPayment = numOfPayment
        self.frequency = frequency
        self.bonusLoanAmount = bonusLoanAmount
        self.bonusFrequency = bonusFrequency
        self.startDate = startDate
        self.calendar = calendar
    }
    
    public var numOfBonusPayment: Int {
        numOfPayment / 6
    }
    
    public var onePaymentAmount: Decimal {
        let monthlyRate = ratePerPayment
        let p = pow(1 + monthlyRate, numOfPayment)
        let amount = loanAmount * monthlyRate * p / (p - 1.0)
        return amount.rounding(.down)
    }

    public var oneBonusPaymentAmount: Decimal? {
        guard let bonusLoanAmount = bonusLoanAmount,
              let bonusFrequency = bonusFrequency else { return nil }
        let calcRateForOnePayment = ratePerYear / Decimal(12) * Decimal(bonusFrequency.onePaymentMonthValue)
        let p = pow(1 + calcRateForOnePayment, numOfBonusPayment)
        let amount = bonusLoanAmount * calcRateForOnePayment * p / (p - 1.0)
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
    
    func calcInteresetPerDays(startDate: Date, nextDate: Date, rounding mode: NSDecimalNumberHandler) -> Decimal {
        // 片端入れのみ対応
        guard let length = (startDate..<nextDate).days(self.calendar) else { fatalError("err in day calc") }
        let interest = loanAmount * ratePerYear / 365 * Decimal(length)
        return interest.rounding(mode)
    }
    
}

extension LoanCondition {
    public static let example = LoanCondition(ratePerYear: 0.0315,
                                              loanAmount: 10_000_000, numOfPayment: 120, frequency: .monthly(at: 10, .noAdjustment),
                                              startDate: Calendar.date(2025, 1, 1))
    public static let bonusExample = LoanCondition(ratePerYear: 0.0315,
                                                   loanAmount: 10_000_000, numOfPayment: 20, frequency: .twiceAYearAt(month: 1, 10, .noAdjustment),
                                                   startDate: Calendar.date(2025, 1, 1))
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
