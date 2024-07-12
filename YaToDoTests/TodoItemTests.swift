//
//  TodoItemTests.swift
//  YaToDoTests
//
//  Created by Danil Masnaviev on 21/06/24.
//

import XCTest
@testable import YaToDo

final class TodoItemTests: XCTestCase {

    func testTodoItemInit() {
        let id = "123"
        let text = "Test"
        let priority = TodoItem.Priority.important
        let deadline = Date()
        let isDone = false
        let dateCreated = Date()
        let dateModified = Date()

        let todo = TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            dateCreated: dateCreated,
            dateModified: dateModified
        )

        XCTAssertEqual(todo.id, id)
        XCTAssertEqual(todo.text, text)
        XCTAssertEqual(todo.priority, priority)
        XCTAssertEqual(todo.deadline, deadline)
        XCTAssertEqual(todo.isDone, isDone)
        XCTAssertEqual(todo.dateCreated, dateCreated)
        XCTAssertEqual(todo.dateModified, dateModified)
    }

    func testTodoItemDefaultInit() {
        let todo = TodoItem(text: "Test")

        XCTAssertEqual(todo.priority, .basic)
        XCTAssertFalse(todo.isDone)
        XCTAssertNotNil(todo.dateCreated)
        XCTAssertNil(todo.dateModified)
    }

    func testTodoItemPriorityComparison() {
        let todoLow = TodoItem(text: "Low", priority: .low)
        let todoBasic = TodoItem(text: "Basic", priority: .basic)
        let todoImportant = TodoItem(text: "Important", priority: .important)
        let todoSame = TodoItem(text: "Test")

        XCTAssertTrue(todoLow.priority < todoBasic.priority)
        XCTAssertTrue(todoLow.priority < todoImportant.priority)
        XCTAssertTrue(todoBasic.priority < todoImportant.priority)
        XCTAssertFalse(todoBasic.priority < todoSame.priority)
        XCTAssertTrue(todoBasic.priority == todoSame.priority)
        XCTAssertTrue(todoImportant.priority > todoLow.priority)
    }
}
