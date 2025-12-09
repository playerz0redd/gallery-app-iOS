//
//  PhotoService.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

final class PhotoService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchPhotosPage(for endpoints: [APIEndpoints]) async -> [UIImage] {
        return await withTaskGroup(of: UIImage.self, returning: [UIImage].self) { group in
            var photos: [UIImage] = []
            for endpoint in endpoints {
                group.addTask {
                    return try! await self.fetchPhoto(for: endpoint)
                }
            }
            
            for await photo in group {
                photos.append(photo)
            }
            return photos
        }
    }
    
    private func fetchPhoto(for endpoint: APIEndpoints) async throws -> UIImage {
        let imageData = try await networkManager.fetchData(endpoint: endpoint)
        guard let image = UIImage(data: imageData) else { return UIImage() }
        return image
    }
}
