//
//  CachingService.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 10.12.25.
//

import UIKit

final class CachingService {
    
    static let shader = CachingService()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func cachePhoto(id: NSString, image: UIImage) {
        cache.setObject(image, forKey: id)
    }
    
    func getPhoto(by id: NSString) -> UIImage? {
        cache.object(forKey: id)
    }
}
