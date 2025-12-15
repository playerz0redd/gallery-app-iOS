//
//  APIEndpoints.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import Foundation

enum APIEndpoints {
    case imageInfo(page: Int)
    case downloadImage(url: String)
    
    static let accessToken: String = "9v4f0Itk2mWXa831ATj5ZbIxu1FIyL6Xw0vpv4wJ7mM"
    static let imagesPerPage = 30
    
    var stringValue: String {
        switch self {
        case .imageInfo(let page):
            "https://api.unsplash.com/photos/?client_id=\(Self.accessToken)&page=\(page)&per_page=\(Self.imagesPerPage)"
        case .downloadImage(let url):
            url
        }
    }
}
