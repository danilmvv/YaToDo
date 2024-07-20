//
//  Endpoints.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 19/07/24.
//

import Foundation

enum Endpoint {
    static let baseURL = URL(string: "https://hive.mrdekk.ru/todo")!

    case getList
    case updateList
    case getItem(id: String)
    case addItem
    case updateItem(id: String)
    case deleteItem(id: String)

    var path: String {
        switch self {
        case .getList, .updateList, .addItem:
            return "/list"
        case .getItem(let id), .updateItem(let id), .deleteItem(let id):
            return "/list/\(id)"
        }
    }

    var url: URL {
        return Endpoint.baseURL.appendingPathComponent(path)
    }
}
