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

public struct PayDay: Sendable {
    let day: Int
    let adjustment: PayDateAdjustment
    let calendar: Calendar
    init(_ day: Int,_ adjustment: PayDateAdjustment,_ calendar: Calendar) {
        self.day = day
        self.adjustment = adjustment
        self.calendar = calendar
    }
    public static func exact(_ day: Int, calendar: Calendar = Calendar.current) -> PayDay {
        .init(day, .noAdjustment, calendar)
    }
    public static func pwd(_ day: Int, calendar: Calendar = Calendar.current) -> PayDay {
        .init(day, .prevWorkingDay, calendar)
    }
    public static func nwd(_ day: Int, calendar: Calendar = Calendar.current) -> PayDay {
        .init(day, .nextWorkingDay, calendar)
    }
    
    public func nextDate(from: Date) -> Date {
        let matchComponent = DateComponents(day: day, hour: 0, minute: 0, second: 0)

        guard let date = calendar.nextDate(after: from.advanced(by: 1), matching: matchComponent, matchingPolicy: .nextTime) else {
            fatalError("failed to calc date")
        }
        return date
    }
}

public struct PayMonthDay: Sendable {
    let month: Int
    let day: Int
    let adjustment: PayDateAdjustment
    init(month: Int, day: Int,_ adjustment: PayDateAdjustment) {
        self.month = month
        self.day = day
        self.adjustment = adjustment
    }
    public static func exact(month: Int, day: Int) -> PayMonthDay {
        .init(month: month, day: day, .noAdjustment)
    }
    public static func pwd(month: Int, day: Int) -> PayMonthDay {
        .init(month: month, day: day, .prevWorkingDay)
    }
    public static func nwd(month: Int, day: Int) -> PayMonthDay {
        .init(month: month, day: day, .nextWorkingDay)
    }
}

public enum PaymentDateFrequency: Sendable {
    case monthly(date: PayDay)
    // case twiceAYear(date: PayMonthDay) // for bonus payment

    var inMonth: Int {
        switch self {
        case .monthly:
            return 1
        }
    }
}
