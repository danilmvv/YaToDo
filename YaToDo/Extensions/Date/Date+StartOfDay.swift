//
//  Date+StartOfDay.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
