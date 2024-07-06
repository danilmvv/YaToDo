//
//  MockData.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 04/07/24.
//

import Foundation

struct MockData {
    static let todos = [
        TodoItem(
            id: "123",
            text: "Купить что-то",
            deadline: Date().addingTimeInterval(8 * 86400),
            dateCreated: Date().addingTimeInterval(-1 * 86400)
        ),
        TodoItem(
            text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно",
            deadline: Date().addingTimeInterval(5 * 86400),
            dateCreated: Date().addingTimeInterval(-2 * 86400)
        ),
        TodoItem(
            text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается многоточие бла бла бла бла бла",
            deadline: Date().addingTimeInterval(5 * 86400),
            dateCreated: Date().addingTimeInterval(-3 * 86400)
        ),
        TodoItem(
            text: "Купить что-то",
            priority: .low,
            category: .study,
            deadline: Date().addingTimeInterval(2 * 86400),
            dateCreated: Date().addingTimeInterval(-4 * 86400)
        ),
        TodoItem(
            text: "Купить что-то",
            priority: .important,
            deadline: Date().addingTimeInterval(2 * 86400),
            dateCreated: Date().addingTimeInterval(-5 * 86400)
        ),
        TodoItem(
            text: "Купить что-то",
            deadline: Date().addingTimeInterval(2 * 86400),
            isDone: true,
            dateCreated: Date().addingTimeInterval(-6 * 86400)
        ),
        TodoItem(
            text: "Задание",
            deadline: Date().addingTimeInterval(86400),
            dateCreated: Date().addingTimeInterval(-7 * 86400)
        ),
        
        TodoItem(
            text: "Купить что-то",
            priority: .important,
            deadline: Date().addingTimeInterval(10 * 86400),
            dateCreated: Date().addingTimeInterval(-8 * 86400)
        ),
        TodoItem(
            text: "Купить что-то",
            category: .work,
            deadline: Date().addingTimeInterval(5 * 86400),
            isDone: true,
            dateCreated: Date().addingTimeInterval(-9 * 86400)
        ),
        TodoItem(
            text: "Задание",
            category: .hobbies,
            deadline: Date().addingTimeInterval(86400),
            dateCreated: Date().addingTimeInterval(-10 * 86400)
        ),
        
        TodoItem(
            text: "Задание",
            dateCreated: Date().addingTimeInterval(-8 * 86400)
        ),
        TodoItem(
            text: "Задание",
            dateCreated: Date().addingTimeInterval(-9 * 86400)
        ),
        TodoItem(
            text: "Задание",
            dateCreated: Date().addingTimeInterval(-10 * 86400)
        )
    ]
}
