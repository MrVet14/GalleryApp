//
//  PhotoModel.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/12/24.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let createdAt: String
    let width: Float
    let height: Float
    let description: String?
    let urls: PhotoURLs
    let user: PhotoUserProfile
    let isLiked: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, description, urls, user, isLiked
    }
}

struct PhotoURLs: Codable {
    let full: String
    let small: String
}

struct PhotoUserProfile: Codable {
    let name: String
}
