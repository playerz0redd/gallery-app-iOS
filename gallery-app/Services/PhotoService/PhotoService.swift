//
//  PhotoService.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

protocol IModelProvider {
    func fetchPhotosModels(page: Int) async throws(AppError) -> [ImageModel]
}

protocol IDataPersistance {
    func savePhotoModel(model: DatabasePhotoModel) throws(DatabaseError)
    func deletePhoto(id: String) throws(DatabaseError)
    func isPhotoLiked(id: String) throws(DatabaseError) -> Bool
}

final class PhotoService {

    private let modelProvider: IModelProvider
    private let persistanceManager: IDataPersistance
    
    init(
        dataProvider: IDataProvider,
        modelProvider: IModelProvider,
        persistanceManager: IDataPersistance
    ) {
        self.dataProvider = dataProvider
        self.modelProvider = modelProvider
        self.persistanceManager = persistanceManager
    }
    
    func fetchPhotosModels(page: Int) async throws(AppError) -> [ImageModel] {
        var photos = try await modelProvider.fetchPhotosModels(page: page)
        for index in 0..<photos.count {
            do {
                if try persistanceManager.isPhotoLiked(id: photos[index].id) {
                    photos[index].isLiked = true
                    photos[index].likes += 1
                }
            } catch let error {
                throw .databaseError(error)
            }
        }
        return photos
    }
    
    func fetchPhotosPage(for endpoints: [APIEndpoints]) async throws(AppError) {
        do {
            try await withThrowingTaskGroup { group in
                for endpoint in endpoints {
                    group.addTask {
                        return try await (endpoint.stringValue, self.fetchPhoto(for: endpoint))
                    }
                }
                
                for try await (id, photo) in group {
                    CachingManager.shared.cachePhoto(id: id as NSString, image: photo)
                }
            }
        } catch let error as AppError {
            throw error
        } catch let error {
            throw .unknownError(error)
        }
    }
    
    func fetchPhoto(for endpoint: APIEndpoints) async throws(AppError) -> UIImage {
        if let image = CachingManager.shared.getPhoto(by: endpoint.stringValue as NSString) {
            return image
        }
        let imageData = try await dataProvider.fetchData(endpoint: endpoint)
        guard let image = UIImage(data: imageData) else { return UIImage() }
        CachingManager.shared.cachePhoto(id: endpoint.stringValue as NSString, image: image)
        return image
    }
    
    func savePhotoModel(model: DatabasePhotoModel) throws(AppError) {
        do {
            try persistanceManager.savePhotoModel(model: model)
        } catch let error {
            throw .databaseError(error)
        }
    }
    
    func deletePhoto(id: String) throws(AppError) {
        do {
            try persistanceManager.deletePhoto(id: id)
        } catch let error {
            throw .databaseError(error)
        }
    }
    
}
