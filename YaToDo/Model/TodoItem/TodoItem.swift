//
//  TodoItem.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 17/06/24.
//

import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: String
    let text: String
    let priority: Priority
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
    
    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .basic,
        deadline: Date? = nil,
        isDone: Bool = false,
        dateCreated: Date = Date(),
        dateModified: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
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
