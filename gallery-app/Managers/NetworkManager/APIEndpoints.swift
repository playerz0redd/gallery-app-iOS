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
    
    private var accessToken: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as? String else { return "" }
        return token
    }
    static let imagesPerPage = 30
    
    var stringValue: String {
        switch self {
        case .imageInfo(let page):
            "https://api.unsplash.com/photos/?client_id=\(accessToken)&page=\(page)&per_page=\(Self.imagesPerPage)"
        case .downloadImage(let url):
            url
        }
    }
}
