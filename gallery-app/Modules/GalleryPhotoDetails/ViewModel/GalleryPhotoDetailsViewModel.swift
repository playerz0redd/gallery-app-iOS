//
//  GalleryPhotoDetailsViewModel.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import Foundation
import UIKit

final class GalleryPhotoDetailsViewModel {
    
    private let photoService: PhotoService
    private var isLoading = false
    private var onLikeButtonPress: (Int, Action) -> Void
    
    var photoModels: [ImageModel]
    var onDataFetch: (([IndexPath]) -> Void)?
    var onError: ((String) -> Void)?
    
    init(
        photoService: PhotoService,
        photoModels: [ImageModel] = [],
        onLikeButtonPress: @escaping (Int, Action) -> Void
    ) {
        self.photoService = photoService
        self.photoModels = photoModels
        self.onLikeButtonPress = onLikeButtonPress
    }
    
    func getPhotoService() -> PhotoService {
        photoService
    }
    
    func fetchNextPageIfNeeded(currentIndex: Int) {
        
        guard !isLoading else { return }
        
        let currentPage = (currentIndex / APIEndpoints.imagesPerPage) + 1
        let nextPage = currentPage + 1
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let startIndex = self.photoModels.endIndex
                let newPhotos = try await photoService.fetchPhotosModels(page: nextPage)
                let endIndex = startIndex + newPhotos.count
                self.photoModels += newPhotos
                
                let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                self.onDataFetch?(indexPaths)
            } catch let error as AppError {
                self.onError?(error.description)
            }
            isLoading = false
        }
        
    }
    
    func toggleLike(at index: Int) {
        
        guard index >= 0 && index < photoModels.count else { return }
        
        let isLiked = photoModels[index].isLiked == true
        
        if isLiked {
            dislikePhoto(at: index)
        } else {
            likePhoto(at: index)
        }
    }
    
    private func likePhoto(at index: Int) {
        
        photoModels[index].likes += 1
        photoModels[index].isLiked = true
        let model = photoModels[index]
        
        do {
            try photoService.savePhotoModel(
                model: .init(
                    id: model.id,
                    description: model.description,
                    likes: model.likes,
                    regularUrl: model.photoUrls.regular,
                    thumbUrl: model.photoUrls.thumb,
                    username: model.user.instagramUsername
                )
            )
            onLikeButtonPress(index, .like)
        } catch let error {
            self.onError?(error.description)
        }
        
    }
    
    private func dislikePhoto(at index: Int) {
        
        photoModels[index].likes -= 1
        photoModels[index].isLiked = false
        let model = photoModels[index]
        
        do {
            try photoService.deletePhoto(id: model.id)
            onLikeButtonPress(index, .dislike)
        } catch let error {
            self.onError?(error.description)
        }
        
    }
}

extension GalleryPhotoDetailsViewModel {
    enum Action {
        case like
        case dislike
    }
}
