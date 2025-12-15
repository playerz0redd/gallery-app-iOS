//
//  ImageModel.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 9.12.25.
//

import Foundation

struct ImageModel: Decodable {
    let id: String
    let width: Int?
    let height: Int?
    let createdDate: Date?
    let description: String?
    let altDescription: String?
    let photoUrls: PhotoUrls
    var likes: Int
    let user: User
    var isLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdDate = "created_at"
        case description
        case altDescription = "alt_description"
        case photoUrls = "urls"
        case likes = "likes"
        case user = "user"
    }
}

struct PhotoUrls: Decodable {
    let raw: String?
    let regular: String
    let thumb: String
}

struct User: Decodable {
    let username: String?
    let instagramUsername: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case instagramUsername = "instagram_username"
    }
}

enum PhotoQuality {
    case raw
    case regular
    case thumb
}
