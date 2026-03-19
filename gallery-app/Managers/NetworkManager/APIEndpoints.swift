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
    
    var url: String {
        
        switch self {
        case .imageInfo(let page):
            var components = URLComponents(string: "https://api.unsplash.com/photos/")
            
            components?.queryItems = [
                URLQueryItem(name: "client_id", value: accessToken),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(Self.imagesPerPage))
            ]
            
            return components?.url?.absoluteString ?? ""
            
        case .downloadImage(let url):
            return url
        }
    }
    
}
