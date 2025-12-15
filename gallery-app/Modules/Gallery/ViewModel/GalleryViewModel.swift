//
//  GalleryViewModel.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import Foundation
import UIKit


class GalleryViewModel {
    
    private let photoService: PhotoService
    var currentPage = 1
    private var isLoading = false
    
    var photoModels: [ImageModel]
    var onDataFetch: (([IndexPath]) -> Void)?
    var onError: ((String) -> Void)?
    
    init(photoService: PhotoService, photoModels: [ImageModel] = []) {
        self.photoService = photoService
        self.photoModels = photoModels
    }
    
    
    func getPhotoService() -> PhotoService {
        self.photoService
    }
    
    func fetchPhotoModelPage() {
        guard !isLoading else { return }
        isLoading.toggle()
        Task { @MainActor in
            do {
                let startIndex = self.photoModels.endIndex
                let newPhotos = try await photoService.fetchPhotosModels(page: self.currentPage)
                let endIndex = startIndex + newPhotos.count
                photoModels += newPhotos
                fetchAndCachePhotos(for: currentPage, photoQuality: .thumb)
                self.changePhotoPage(to: currentPage + 1)
                let indexPath = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
                self.onDataFetch?(indexPath)
            } catch let error as AppError {
                self.onError?(error.description)
            }
            isLoading.toggle()
        }
    }
    
    func changePhotoPage(to page: Int) {
        self.currentPage = page
    }
    
    func fetchAndCachePhotos(for page: Int, photoQuality: PhotoQuality) {
        let start = (page - 1) * APIEndpoints.imagesPerPage
        let sliceEnd = page * APIEndpoints.imagesPerPage
        let end = sliceEnd > photoModels.count ? photoModels.count : sliceEnd
        guard start <= end else { return }
        let endpoints: [APIEndpoints] = photoModels[start..<end].map { imageModel in
            switch photoQuality {
            case .raw:
                .downloadImage(url: imageModel.photoUrls.raw ?? "")
            case .regular:
                .downloadImage(url: imageModel.photoUrls.regular)
            case .thumb:
                .downloadImage(url: imageModel.photoUrls.thumb)
            }
        }
        Task {
            do {
                try await photoService.fetchPhotosPage(for: endpoints)
            } catch let error as AppError {
                self.onError?(error.description)
            }
        }
    }
    
    func deletePhoto(id: String) {
        do {
            try photoService.deletePhoto(id: id)
        } catch let error {
            self.onError?(error.description)
        }
    }
    
    func savePhotoModel(model: DatabasePhotoModel) {
        do {
            try photoService.savePhotoModel(model: model)
        } catch let error {
            self.onError?(error.description)
        }
    }
    
}
