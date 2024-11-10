//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSFoundationExtension

public enum PayDateAdjustment: String, RawRepresentable, Codable, CaseIterable, Sendable {
    case noAdjustment, nextWorkingDay, prevWorkingDay
}

public struct PaymentDateFrequency: Sendable, Codable, Hashable {
    let matchComponent: [DateComponents] // components should be spread equally ok: 1,3,5,7,9,11   ng: 1,2,3,8,9 (in month)
    let adjustment: PayDateAdjustment
    let calendar: Calendar
    
    public let onePaymentMonthValue: Int
    
    public init(matchComponent: [DateComponents], adjustment: PayDateAdjustment, calendar: Calendar = Calendar.current, ratio: Int) {
        self.matchComponent = matchComponent
        self.adjustment = adjustment
        self.calendar = calendar
        self.onePaymentMonthValue = ratio
    }
    
    public var firstPayDay: Int {
        guard let firstMatch = matchComponent.first,
              let firstDay = firstMatch.day else { fatalError("invalid matchComponent") }
        return firstDay
    }

    public var twicePayMonthAYear: MonthPair {
        guard matchComponent.count == 2,
              let firstMonth = matchComponent[0].month,
              let secondMonth = matchComponent[1].month else { fatalError("invalid matchComponent") }
        return MonthPair(firstMonth, secondMonth)
    }
    
    public func nextDate(from fromDate: Date) -> Date? {
        var dates: Set<Date> = Set()
        for match in matchComponent {
            calendar.enumerateDates(startingAfter: fromDate,
                                    matching: match,
                                    matchingPolicy: .strict) { result, _, stop in
                defer { stop = true }
                guard let newDate = result else { return }
                dates.insert(newDate)
            }
        }
        return dates.sorted().first
    }
}

public struct MonthPair: Hashable {
    public var month1: Int
    public var month2: Int
    
    public init(_ month1: Int,_ month2: Int) {
        self.month1 = min(month1, month2)
        self.month2 = max(month1, month2)
    }
}

extension PaymentDateFrequency {
    public static func monthly(at day: Int,_ adjustment: PayDateAdjustment, calendar: Calendar = Calendar.current) -> PaymentDateFrequency {
        let component = DateComponents(day: day, hour: 0, minute: 0, second: 0)
        return PaymentDateFrequency(matchComponent: [component], adjustment: adjustment, calendar: calendar, ratio: 1)
    }
    public static func twiceAYear(at month: Int,_ day: Int,_ adjustment: PayDateAdjustment, calendar: Calendar = Calendar.current) -> PaymentDateFrequency {
        let component1 = DateComponents(month: month, day: day, hour: 0, minute: 0, second: 0)
        let anotherMonth = (month + 6) % 12
        let component2 = DateComponents(month: anotherMonth, day: day, hour: 0, minute: 0, second: 0)
        return PaymentDateFrequency(matchComponent: [component1, component2], adjustment: adjustment, calendar: calendar, ratio: 6)
    }
}
