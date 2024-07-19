//
//  DefaultNetworkingService.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 19/07/24.
//

import Foundation

class DefaultNetworkingService: NetworkingService {
    private let session: URLSession
    private let token: String
    private var isDirty: Bool = false
    private var revision: Int = 0

    init(session: URLSession = .shared, token: String) {
        self.session = session
        self.token = token
    }

    private func createRequest(endpoint: Endpoint, method: HTTPMethod, revision: Int? = nil, body: Any? = nil) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let revision = revision {
            request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        }
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

    private func handleResponse(data: Data, response: URLResponse) throws -> [String: Any] {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }

        switch httpResponse.statusCode {
        case 200:
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw NetworkingError.parsingError
            }
            return json
        case 400:
            throw NetworkingError.badRequest
        case 401:
            throw NetworkingError.unauthorized
        case 404:
            throw NetworkingError.notFound
        case 500:
            throw NetworkingError.serverError
        default:
            throw NetworkingError.unknown
        }
    }

    func fetchTodoList() async throws -> [TodoItem] {
        let request = createRequest(endpoint: .getList, method: .GET)
        let (data, response) = try await session.dataTask(for: request)
        let json = try handleResponse(data: data, response: response)
        guard let list = json["list"] as? [[String: Any]], let revision = json["revision"] as? Int else {
            throw NetworkingError.parsingError
        }
        let items = list.compactMap(TodoItem.parse)
        self.revision = revision
        self.isDirty = false
        return items
    }

    func updateTodoList(_ items: [TodoItem]) async throws -> [TodoItem] {
        let request = createRequest(endpoint: .updateList, method: .PATCH, revision: revision, body: ["list": items.map { $0.json }])
        let (data, response) = try await session.dataTask(for: request)
        let json = try handleResponse(data: data, response: response)
        guard let list = json["list"] as? [[String: Any]], let revision = json["revision"] as? Int else {
            throw NetworkingError.parsingError
        }
        let items = list.compactMap(TodoItem.parse)
        self.revision = revision
        self.isDirty = false
        return items
    }

    func fetchTodoItem(id: String) async throws -> TodoItem {
        let request = createRequest(endpoint: .getItem(id: id), method: .GET)
        let (data, response) = try await session.dataTask(for: request)
        let json = try handleResponse(data: data, response: response)
        guard let item = TodoItem.parse(json: json) else {
            throw NetworkingError.parsingError
        }
        return item
    }

    func addTodoItem(_ item: TodoItem) async throws -> TodoItem {
        let request = createRequest(endpoint: .addItem, method: .POST, revision: revision, body: item.json)
        let (data, response) = try await session.dataTask(for: request)
        let json = try handleResponse(data: data, response: response)
        guard let element = json["element"] as? [String: Any],
              let item = TodoItem.parse(json: element),
              let revision = json["revision"] as? Int else {
            throw NetworkingError.parsingError
        }
        self.revision = revision
        self.isDirty = false
        return item
    }

    func updateTodoItem(_ item: TodoItem) async throws -> TodoItem {
        let request = createRequest(endpoint: .updateItem(id: item.id), method: .PUT, revision: revision, body: item.json)
        let (data, response) = try await session.dataTask(for: request)
        let json = try handleResponse(data: data, response: response)
        guard let element = json["element"] as? [String: Any],
              let item = TodoItem.parse(json: element),
              let revision = json["revision"] as? Int else {
            throw NetworkingError.parsingError
        }
        self.revision = revision
        self.isDirty = false
        return item
    }

    func deleteTodoItem(id: String) async throws -> TodoItem {
        let request = createRequest(endpoint: .deleteItem(id: id), method: .DELETE, revision: revision)
        let (data, response) = try await session.dataTask(for: request)
        let json = try handleResponse(data: data, response: response)
        guard let element = json["element"] as? [String: Any],
              let item = TodoItem.parse(json: element),
              let revision = json["revision"] as? Int else {
            throw NetworkingError.parsingError
        }
        self.revision = revision
        self.isDirty = false
        return item
    }
}
