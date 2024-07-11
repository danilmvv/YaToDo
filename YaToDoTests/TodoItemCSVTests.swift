//
//  TodoItemCSVTests.swift
//  YaToDoTests
//
//  Created by Danil Masnaviev on 25/06/24.
//

import XCTest
@testable import YaToDo

final class TodoItemCSVTests: XCTestCase {

    func testCSVSerialization() {
        let todoItem = TodoItem(
            id: "123",
            text: "Test",
            priority: .important,
            deadline: Date(timeIntervalSince1970: 1718971200),
            isDone: false,
            dateCreated: Date(timeIntervalSince1970: 1718971200),
            dateModified: Date(timeIntervalSince1970: 1718971200)
        )

        let csv = todoItem.csv

        let expectedCSV = "123,Test,false,1718971200.0,important,1718971200.0,1718971200.0"
        XCTAssertEqual(csv, expectedCSV)
    }

    func testCSVDeserialization() {
        let csv = "123,Test,false,1718971200.0,important,1718971200.0,1718971200.0"

        let todoItem = TodoItem.parse(csv: csv)

        XCTAssertEqual(todoItem?.id, "123")
        XCTAssertEqual(todoItem?.text, "Test")
        XCTAssertEqual(todoItem?.priority, .important)
        XCTAssertEqual(todoItem?.deadline?.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.isDone, false)
        XCTAssertEqual(todoItem?.dateCreated.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.dateModified?.timeIntervalSince1970, 1718971200.0)
    }

    func testCSVSerializationWithCommas() {
        let todoItem = TodoItem(
            id: "123",
            text: "Testing, separators, 123",
            priority: .important,
            deadline: Date(timeIntervalSince1970: 1718971200),
            isDone: false,
            dateCreated: Date(timeIntervalSince1970: 1718971200),
            dateModified: Date(timeIntervalSince1970: 1718971200)
        )

        let csv = todoItem.csv

        let expectedCSV = "123,\"Testing, separators, 123\",false,1718971200.0,important,1718971200.0,1718971200.0"
        XCTAssertEqual(csv, expectedCSV)
    }

    func testCSVDeserializationWithCommas() {
        let csv = "123,\"Testing, separators, 123\",false,1718971200.0,important,1718971200.0,1718971200.0"

        let todoItem = TodoItem.parse(csv: csv)

        XCTAssertEqual(todoItem?.id, "123")
        XCTAssertEqual(todoItem?.text, "Testing, separators, 123")
        XCTAssertEqual(todoItem?.priority, .important)
        XCTAssertEqual(todoItem?.deadline?.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.isDone, false)
        XCTAssertEqual(todoItem?.dateCreated.timeIntervalSince1970, 1718971200.0)
        XCTAssertEqual(todoItem?.dateModified?.timeIntervalSince1970, 1718971200.0)
    }

    func testTodoItemFromInvalidCSVMissingFields() {
        let csv = "123,,false,,,,"

        let todoItem = TodoItem.parse(csv: csv)
        XCTAssertNil(todoItem, "CSV Deserialization With Missing Required Fields Failed")
    }

}
