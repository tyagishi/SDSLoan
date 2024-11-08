//
//  Calendar+Extensions.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

extension Calendar {
    public func adjustDate(_ date: Date, adjust: PayDateAdjustment) -> Date {
        switch adjust {
        case .noAdjustment: return date
        case .nextWorkingDay:
            guard let weekday = self.dateComponents([.weekday], from: date).weekday,
                  ((weekday == 1)||(weekday == 7)) else { return date }
            if let nWorking = endOf(weekday: 1, from: date) { return nWorking.advanced(.seconds(1)) }
            fatalError("failed to find")
        case .prevWorkingDay:
            guard let weekday = self.dateComponents([.weekday], from: date).weekday,
                  ((weekday == 1)||(weekday == 7)) else { return date }
            if let nWorking = startOf(weekday: 6, from: date) { return nWorking }
            fatalError("failed to find")
        }
    }
    
    static func date(_ year: Int,_ month: Int,_ day: Int) -> Date {
        current.date(from: DateComponents(year: year, month: month, day: day))!
    }
}
