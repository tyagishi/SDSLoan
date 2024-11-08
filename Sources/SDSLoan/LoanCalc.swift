//
//  LoanCalc.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSFoundationExtension
import SDSSwiftExtension

class LoanCalc {
    public static func paymentDates(start startDate: Date, num: Int, frequency: PaymentDateFrequency) -> any Sequence<Date> {
        var retDates: Set<Date> = []
        
        for match in frequency.matchComponent {
            var count = 0
            Calendar.current.enumerateDates(startingAfter: startDate,
                                            matching: match,
                                            matchingPolicy: .strict) { result, _, stop in
                guard let newDate = result else { return }
                retDates.insert(newDate)
                count += 1
                guard count < num else { stop = true; return }
            }
        }
        guard retDates.count >= num else { fatalError("too few dates") }
        let sortedDates = retDates.map({ frequency.calendar.adjustDate($0, adjust: frequency.adjustment) }).sorted()
        return sortedDates[0..<num]
    }
    
    public static func payments(firstPrincipal: Decimal, condition: LoanCondition) -> [LoanPayment] {
        var payments: [LoanPayment] = []
        
        let pdates = paymentDates(start: condition.startDate, num: condition.numOfPayment,
                                  frequency: condition.frequency).map({ $0 })
        guard !pdates.isEmpty else { return []}
        
        // first
        var interest = condition.onePaymentAmount - firstPrincipal
        var balance = condition.loanAmount - firstPrincipal
        var lastPay = LoanPayment(date: pdates.first!,
                                  principal: firstPrincipal, interest: interest, balanceAfterThisPayment: balance)
        payments.append(lastPay)

        var ite = pdates.makePairIterator()
        _ = ite.next() // since first pay processed
        while let (current, next) = ite.next() {
            interest = condition.calcInterest(lastPay: lastPay, nextDate: current, rounding: .down)
            let principal: Decimal
            if next != nil {
                principal = condition.onePaymentAmount - interest
                balance = lastPay.balanceAfterThisPayment - principal
            } else {
                // last payment
                principal = lastPay.balanceAfterThisPayment
                balance = 0
            }
            let nextPay = LoanPayment(date: current, principal: principal, interest: interest, balanceAfterThisPayment: balance)
            payments.append(nextPay)
            lastPay = nextPay
        }
        
        return payments
    }
    
}
