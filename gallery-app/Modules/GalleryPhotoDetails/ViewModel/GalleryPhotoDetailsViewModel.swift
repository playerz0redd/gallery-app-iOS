//
//  GalleryPhotoDetailsViewModel.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import Foundation

final class GalleryPhotoDetailsViewModel: GalleryViewModel {
    
    private var onLikeButtonPress: (Int, Action) -> Void
    
    enum Action {
        case like
        case dislike
    }
    
    func changeButtonState(at index: Int) {
        if self.photoModels[index].isLiked == true {
            self.photoModels[index].likes -= 1
            deletePhoto(id: self.photoModels[index].id)
            self.photoModels[index].isLiked = false
            onLikeButtonPress(index, .dislike)
        } else {
            self.photoModels[index].likes += 1
            let model = self.photoModels[index]
            savePhotoModel(
                model: .init(
                    id: model.id,
                    description: model.description,
                    likes: model.likes,
                    regularUrl: model.photoUrls.regular,
                    thumbUrl: model.photoUrls.thumb,
                    username: model.user.instagramUsername
                )
            )
            self.photoModels[index].isLiked = true
            onLikeButtonPress(index, .like)
        }
    }
    
    init(
        photoService: PhotoService,
        photoModels: [ImageModel] = [],
        onLikeButtonPress: @escaping (Int, Action) -> Void
    ) {
        self.onLikeButtonPress = onLikeButtonPress
        super.init(photoService: photoService, photoModels: photoModels)
    }
    
    func getNextPage(photoIndex: Int) -> Int {
        photoIndex / 30 + 2
    }
    
}
