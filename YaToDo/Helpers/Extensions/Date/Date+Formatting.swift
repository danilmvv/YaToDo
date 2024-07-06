//
//  Date+Formatting.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 26/06/24.
//

import Foundation

extension Date {
    func formattedDayMonth() -> String {
        return formatted(with: "d MMMM")
    }
    
    func formattedDayMonthYear() -> String {
        return formatted(with: "d MMMM yyyy")
    }
    
    private func formatted(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
