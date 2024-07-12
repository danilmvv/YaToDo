//
//  TodoItem.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import Foundation
import SwiftUI

struct TodoItem: Identifiable, Equatable, Hashable {
    let id: String
    let text: String
    let priority: Priority
    let category: Category
    let color: String
    let deadline: Date?
    let isDone: Bool
    let dateCreated: Date
    let dateModified: Date?

    enum Priority: String, CaseIterable, Comparable {
        case low
        case basic
        case important

        /// Функция для сравнения пиоритетов
        static func < (lhs: Priority, rhs: Priority) -> Bool {
            switch (lhs, rhs) {
            case (.low, _):
                return true
            case (.basic, .important):
                return true
            default:
                return false
            }
        }

        var icon: String {
            switch self {
            case .low:
                return "arrow.down"
            case .basic:
                return "нет"
            case .important:
                return "exclamationmark.2"
            }
        }
    }

    struct Category: Identifiable, Equatable, Hashable {
        let id: String
        var name: String
        var color: Color

        static let work = Category(id: UUID().uuidString, name: "Работа", color: .red)
        static let study = Category(id: UUID().uuidString, name: "Учеба", color: .blue)
        static let hobbies = Category(id: UUID().uuidString, name: "Хобби", color: .green)
        static let other = Category(id: UUID().uuidString, name: "Другое", color: .clear)

        static let predefined: [Category] = [.work, .study, .hobbies]
    }

    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .basic,
        category: Category = .other,
        color: String = Color.random().toHexString(),
        deadline: Date? = nil,
        isDone: Bool = false,
        dateCreated: Date = Date(),
        dateModified: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.category = category
        self.color = color
        self.deadline = deadline
        self.isDone = isDone
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
}

extension TodoItem {
    enum CodingKeys: String, CaseIterable {
        case id = "id"
        case text = "text"
        case isDone = "done"
        case priority = "importance"
        case deadline = "deadline"
        case dateCreated = "created_at"
        case dateModified = "changed_at"
    }
}
