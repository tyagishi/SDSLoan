//
//  LoanPayment.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

public struct LoanPayment: Equatable, Sendable, Codable{
    public let date: Date // 0:00
    public let principal: Decimal
    public let interest: Decimal
    public let balanceAfterThisPayment: Decimal
}

extension Array where Element == LoanPayment {
    func payment(at date: Date) -> LoanPayment? {
        self.first(where: { $0.date == date })
    }
}
