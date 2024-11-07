//
//  LoanCalc.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

class LoanCalc {
    public static func paymentDates(start startDate: Date, num: Int, frequency: PaymentDateFrequency, in calendar: Calendar) -> [Date] {
        let matchComponent: DateComponents
        switch frequency {
        case .monthly(let date):
            matchComponent = DateComponents(day: date.day, hour: 0, minute: 0, second: 0)
        }
        
        var retDates: [Date] = []
        var count = 0
        switch frequency {
        case .monthly(let date):
            Calendar.current.enumerateDates(startingAfter: startDate,
                                            matching: matchComponent,
                                            matchingPolicy: .strict) { result, _, stop in
                guard let newDate = result else { return }
                let adjustedDate = calendar.adjustDate(newDate, adjust: date.adjustment)
                retDates.append(adjustedDate)
                count += 1
                guard count < num else { stop = true; return }
            }
        }
        return retDates
    }
    
    public static func payments(condition: LoanCondition, frequency: PaymentDateFrequency, in calendar: Calendar) -> [LoanPayment] {
        []
    }
}


//public func calcLoanPayments(firstPrincipal: Decimal, calcNum: Int) throws -> [LoanPayment] {
//    var payments: [LoanPayment] = []
////    var rest = restAmount - firstPrincipal
////    let interest = self.monthlyPayment - firstPrincipal
////    payments.append(LoanPayment(principal: firstPrincipal, interest: interest,
////                                balanceAfterThisPay: rest))
//    // process next in the loop
//    for _ in 0..<(calcNum-1) {
//        let interest = ((rest * self.interestRatePerYear) / 12).rounded(0, .down)
//        let principal = self.monthlyPayment - interest
//        guard Decimal(1) < principal else { throw LoanCalcError.infinitLoop }
//        rest -= principal
//        payments.append(LoanPayment(principal: principal, interest: interest, balanceAfterThisPay: rest))
//    }
//    // adjust last payment
//    if rest < 0,
//       let last = payments.last {
//        payments.removeLast()
//        let newLast = LoanPayment(principal: last.principal + rest,
//                                  interest: last.interest, balanceAfterThisPay: Decimal(0))
//        payments.append(newLast)
//    }
//    return payments
//}