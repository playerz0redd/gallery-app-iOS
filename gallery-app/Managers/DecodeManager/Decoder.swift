//
//  Decoder.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import Foundation

struct Decoder {
    
    static func decode<T: Decodable>(type: T.Type, data: Data) throws(AppError) -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw .networkError(.decoderError(error))
        }
    }
    
}
