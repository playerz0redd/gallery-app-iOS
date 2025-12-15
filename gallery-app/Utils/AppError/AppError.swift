//
//  AppError.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 15.12.25.
//

import Foundation

enum AppError: Error {
    
    case networkError(NetworkError)
    case databaseError(DatabaseError)
    case unknownError(Error)
    
    var description: String {
        switch self {
        case .networkError(let networkError):    networkError.description
        case .databaseError(let databaseError):  databaseError.description
        case .unknownError(let error):           error.localizedDescription
        }
    }
    
}
