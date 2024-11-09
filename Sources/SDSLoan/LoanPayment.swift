//
//  LoanPayment.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanPayment: Identifiable, Equatable, Sendable, Codable{
    public var id: UUID = UUID()
    public let date: Date // 0:00
    public let principal: Decimal
    public let interest: Decimal
    public let balanceAfterThisPayment: Decimal
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
}
