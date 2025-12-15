//
//  CoreDataErrors.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 15.12.25.
//

import Foundation

enum DatabaseError: Error {
    case saveError(Error)
    case writeError(Error)
    case fetchError(Error)
    
    var description: String {
        switch self {
        case .saveError:    "Databse saving error"
        case .writeError:   "Database writing error"
        case .fetchError:   "Database fetching error"
        }
    }
}
