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
    
    private static let accessToken: String = Bundle.main.object(forInfoDictionaryKey: "API_TOKEN") as! String
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
