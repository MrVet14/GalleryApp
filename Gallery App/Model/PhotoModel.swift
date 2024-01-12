//
//  PhotoModel.swift
//  Gallery App
//
//  Created by Vitali Vyucheiski on 1/12/24.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let color: String?
    let description: String?
    let urls: PhotoURLs
    let user: PhotosUserProfile

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case color, description, urls, user
    }
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}

struct PhotosUserProfile: Codable {
    let id: String
    let username: String
    let name: String?
    let firstName: String?
    let lastName: String?
    let portfolioURL: String?
    let bio: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case portfolioURL = "portfolio_url"
        case bio, location
    }
}
