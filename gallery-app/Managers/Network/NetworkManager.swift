//
//  NetworkManager.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import Foundation

final class NetworkManager: IModelProvider, IDataProvider {
    
    func fetchPhotosModels(page: Int) async throws(AppError) -> [ImageModel] {
        let data = try await self.fetchData(endpoint: APIEndpoints.imageInfo(page: page))
        return try Decoder.decode(type: [ImageModel].self, data: data)
    }
    
    
    func fetchData(endpoint: APIEndpoints) async throws(AppError) -> Data {
        guard let url = URL(string: endpoint.stringValue) else { throw .photoModelError }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                throw NetworkError.serverError(serverError: .statusCode(code: response.statusCode))
            }
            return data
        } catch let error {
            throw .networkError(.internetError(error))
        }
    }
    
}
