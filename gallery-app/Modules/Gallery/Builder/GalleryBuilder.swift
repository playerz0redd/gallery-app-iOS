//
//  GalleryBuilder.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 16.12.25.
//

import Foundation
import UIKit

final class GalleryModuleBuilder {
    
    enum GalleryModuleType {
        case gallery
        case favorites
        
        var title: String {
            switch self {
            case .gallery:       "Gallery"
            case .favorites:     "Favorites"
            }
        }
        
        var imageName: String {
            switch self {
            case .gallery:       "photo.on.rectangle"
            case .favorites:     "heart.fill"
            }
        }
    }
    
    static func build(
        dataProvider: NetworkManager,
        persistanceProvider: CoreDataManager,
        cachingManager: IDataCache,
        type: GalleryModuleType
    ) -> GalleryViewController {
        
        let modelProvider: IModelProvider = type == .favorites ? persistanceProvider : dataProvider
        let photoService: PhotoService = .init(
            dataProvider: dataProvider,
            modelProvider: modelProvider,
            persistanceManager: persistanceProvider,
            cachingManager: cachingManager
        )
        let viewModel = GalleryViewModel(photoService: photoService)
        let viewController = GalleryViewController(viewModel: viewModel)
        viewController.navigationItem.title = type.title
        
        return viewController
    }
    
}
