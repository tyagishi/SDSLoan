//
//  Range+Extensions.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/07
//  © 2024  SmallDeskSoftware
//

import Foundation

extension Range where Bound == Date {
    public func days(_ calendar: Calendar) -> Int? {
        calendar.dateComponents([.day], from: self.lowerBound, to: self.upperBound).day
    }
    public func months(_ calendar: Calendar) -> Int? {
        calendar.dateComponents([.month], from: self.lowerBound, to: self.upperBound).month
    }
}
