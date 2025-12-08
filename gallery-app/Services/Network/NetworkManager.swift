//
//  NetworkManager.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import Foundation

final class NetworkManager {
    
    func fetchData(endpoint: APIEndpoints) async throws -> Data {
        let url = URL(string: endpoint.stringValue)!
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        return data
    }
}
