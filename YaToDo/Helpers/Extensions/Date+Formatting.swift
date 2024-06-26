//
//  Date+Formatting.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 26/06/24.
//

import Foundation

extension Date {
    func formattedDayMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: self)
    }
}
