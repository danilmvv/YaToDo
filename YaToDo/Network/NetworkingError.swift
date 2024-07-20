//
//  NetworkingError.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 19/07/24.
//

import Foundation

enum NetworkingError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case unknown
    case parsingError
    case cancellationError
}
