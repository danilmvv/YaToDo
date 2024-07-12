//
//  TodoItem+Cacheable.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 25/06/24.
//

import Foundation
import FileCache

extension TodoItem: Cacheable {

    // MARK: JSON Parsing

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

    // MARK: CSV Parsing

    static func parse(csv: String) -> TodoItem? {
        var components = [String]()
        var currentComponent = ""
        var insideQuotes = false

        for char in csv {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }
        }

        components.append(currentComponent)

        guard components.count == 7 else {
            return nil
        }

        let id = components[0]
        let text = parseCSVSeparator(component: components[1])
        guard !text.isEmpty else {
            return nil
        }

        let isDone = Bool(components[2]) ?? false
        let dateCreatedInterval = TimeInterval(components[3]) ?? Date().timeIntervalSince1970

        let dateCreated = Date(timeIntervalSince1970: dateCreatedInterval)

        let importanceString = components[4].isEmpty ? Priority.basic.rawValue : components[4]
        guard let priority = Priority(rawValue: importanceString) else {
            return nil
        }

        let deadlineInterval = TimeInterval(components[5])
        let deadline = deadlineInterval != nil ? Date(timeIntervalSince1970: deadlineInterval!) : nil

        let dateModifiedInterval = TimeInterval(components[6])
        let dateModified = dateModifiedInterval != nil ? Date(timeIntervalSince1970: dateModifiedInterval!) : nil

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

    var csv: String {
        var csvString = "\(id),\(escapeCSVSeparator(component: text)),\(isDone),\(dateCreated.timeIntervalSince1970),"

        if priority != .basic {
            csvString += "\(priority.rawValue),"
        } else {
            csvString += ","
        }

        if let deadline = deadline {
            csvString += "\(deadline.timeIntervalSince1970),"
        } else {
            csvString += ","
        }

        if let dateModified = dateModified {
            csvString += "\(dateModified.timeIntervalSince1970)"
        }

        return csvString
    }

    private func escapeCSVSeparator(component: String) -> String {
        var escapedComponent = component

        // Оборачиваем в кавычки
        escapedComponent = escapedComponent.replacingOccurrences(of: "\"", with: "\"\"")
        if escapedComponent.contains(",") || escapedComponent.contains("\"") {
            escapedComponent = "\"\(escapedComponent)\""
        }

        return escapedComponent
    }

    private static func parseCSVSeparator(component: String) -> String {
        var parsedComponent = component

        // Убираем кавычки
        if parsedComponent.hasPrefix("\"") && parsedComponent.hasSuffix("\"") {
            parsedComponent.removeFirst()
            parsedComponent.removeLast()
        }

        parsedComponent = parsedComponent.replacingOccurrences(of: "\"\"", with: "\"")

        return parsedComponent
    }
}
