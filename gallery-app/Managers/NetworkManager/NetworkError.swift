//
//  NetworkErrors.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 14.12.25.
//

import Foundation

enum NetworkError: Error {
    
    case serverError(serverError: ServerError)
    case internetError(Error)
    case decoderError(Error)
    
    enum ServerError {
        case statusCode(code: Int)
    }
    
    var description: String {
        switch self {
        case .serverError(let serverError):       "Server error \(serverError)"
        case .internetError(let error):           "Internet error \(error.localizedDescription)"
        case .decoderError(let error):            "Data decoder error \(error.localizedDescription)"
        }
    }
    
}
