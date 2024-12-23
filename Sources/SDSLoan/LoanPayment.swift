//
//  LoanPayment.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanPayment: Identifiable, Equatable, Sendable, Codable{
    public static func == (lhs: LoanPayment, rhs: LoanPayment) -> Bool {
        lhs.date == rhs.date &&
        lhs.principal == rhs.principal &&
        lhs.interest == rhs.interest &&
        lhs.balanceAfterThisPayment == rhs.balanceAfterThisPayment 
//        lhs.bonusPrincipal == rhs.bonusPrincipal &&
//        lhs.bonusInterest == rhs.bonusInterest &&
//        lhs.bonusBalanceAfterThisPayment == rhs.bonusBalanceAfterThisPayment
    }
    public var id: UUID = UUID()
    public let date: Date // 0:00
    public let principal: Decimal
    public let interest: Decimal
    public let balanceAfterThisPayment: Decimal
//    public let bonusPrincipal: Decimal?
//    public let bonusInterest: Decimal?
//    public let bonusBalanceAfterThisPayment: Decimal?
}

public struct PaidAmount: Identifiable, Equatable, Sendable, Codable {
    public var id: UUID
    public let date: Date
    public let principal: Decimal
    public let interest: Decimal
    public let total: Decimal // incl. this payment

    public init(id: UUID = UUID(), date: Date, principal: Decimal, interest: Decimal) {
        self.id = id
        self.date = date
        self.principal = principal
        self.interest = interest
        self.total = principal + interest
    }
    
    public static let zero = PaidAmount(date: Date.distantPast, principal: 0, interest: 0)
}

extension Array where Element == LoanPayment {
    public func payment(at date: Date) -> LoanPayment? {
        self.first(where: { $0.date == date })
    }
    
    public func paymentSum() -> (total: Decimal, principal: Decimal, interest: Decimal) {
        var principal = Decimal(0)
        var interest = Decimal(0)
        self.forEach({
            principal += $0.principal
            interest += $0.interest
        })
        return (principal+interest, principal, interest)
    }
    
    public func debugPrint() {
        forEach({
            print("\($0.date), \($0.principal), \($0.interest), \($0.balanceAfterThisPayment)")
        })
    }
}
