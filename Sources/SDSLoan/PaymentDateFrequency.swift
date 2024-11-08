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

public struct PaymentDateFrequency: Sendable {
    let matchComponent: [DateComponents]
    let adjustment: PayDateAdjustment
    let calendar: Calendar
    
    public init(matchComponent: [DateComponents], adjustment: PayDateAdjustment, calendar: Calendar = Calendar.current) {
        self.matchComponent = matchComponent
        self.adjustment = adjustment
        self.calendar = calendar
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

extension PaymentDateFrequency {
    public static func monthly(at day: Int,_ adjustment: PayDateAdjustment, calendar: Calendar = Calendar.current) -> PaymentDateFrequency {
        let component = DateComponents(day: day, hour: 0, minute: 0, second: 0)
        return PaymentDateFrequency(matchComponent: [component], adjustment: adjustment, calendar: calendar)
    }
    public static func twiceAYear(at month: Int,_ day: Int,_ adjustment: PayDateAdjustment, calendar: Calendar = Calendar.current) -> PaymentDateFrequency {
        let component1 = DateComponents(month: month, day: day, hour: 0, minute: 0, second: 0)
        let anotherMonth = (month + 6) % 12
        let component2 = DateComponents(month: anotherMonth, day: day, hour: 0, minute: 0, second: 0)
        return PaymentDateFrequency(matchComponent: [component1, component2], adjustment: adjustment, calendar: calendar)
    }
}
