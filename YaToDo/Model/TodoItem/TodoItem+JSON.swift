//
//  TodoItem+JSON.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any] else {
            return nil
        }
        
        // Обязательные поля
        guard let id = dict[CodingKeys.id.rawValue] as? String,
              let text = dict[CodingKeys.text.rawValue] as? String,
              let isDone = dict[CodingKeys.isDone.rawValue] as? Bool,
              let dateCreatedInterval = dict[CodingKeys.dateCreated.rawValue] as? TimeInterval
        else {
            return nil
        }
        
        let dateCreated = Date(timeIntervalSince1970: dateCreatedInterval)
        
        // Проверка опциональных полей
        let priorityString = dict[CodingKeys.priority.rawValue] as? String ?? Priority.basic.rawValue
        guard let priority = Priority(rawValue: priorityString) else {
            return nil
        }
        
        let deadline: Date?
        if let deadlineInterval = dict[CodingKeys.deadline.rawValue] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineInterval)
        } else {
            deadline = nil
        }
        
        let dateModified: Date?
        if let dateModifiedInterval = dict[CodingKeys.dateModified.rawValue] as? TimeInterval {
            dateModified = Date(timeIntervalSince1970: dateModifiedInterval)
        } else {
            dateModified = nil
        }
        
        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            dateCreated: dateCreated,
            dateModified: dateModified
        )
    }
    
    var json: Any {
        var dict: [String: Any] = [
            CodingKeys.id.rawValue: id,
            CodingKeys.text.rawValue: text,
            CodingKeys.isDone.rawValue: isDone,
            CodingKeys.dateCreated.rawValue: dateCreated.timeIntervalSince1970
        ]
        
        if priority != .basic {
            dict[CodingKeys.priority.rawValue] = priority.rawValue
        }
        
        if let deadline = deadline {
            dict[CodingKeys.deadline.rawValue] = deadline.timeIntervalSince1970
        }
        
        if let dateModified = dateModified {
            dict[CodingKeys.dateModified.rawValue] = dateModified.timeIntervalSince1970
        }
        
        return dict
    }
}
