//
//  Users.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import Foundation


typealias Users = [UserModel]

// MARK: - UserModel
struct UserModel: Codable {
    let id, color: String
    let width, height, likes: Int
    let likedByUser: Bool
    let createdAt: String
    let user: User
    let currentUserCollections: [UserCollection]
    let urls: Urls
    let categories: [Category]
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color, likes
        case likedByUser = "liked_by_user"
        case currentUserCollections = "current_user_collections"
        case user, urls, categories, links
    }
}


// MARK: - User
struct User: Codable {
    let id, username, name: String
    let profileImage: ProfileImage
    let links: UserLinks
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, links
        case profileImage = "profile_image"
    }
}


// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}


// MARK: - UserLinks
struct UserLinks: Codable {
    let userLinksSelf, html, photos, likes: String
    
    enum CodingKeys: String, CodingKey {
        case userLinksSelf = "self"
        case html, photos, likes
    }
}


// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small, thumb: String
}


// MARK: - Category
struct Category: Codable {
    let id, photoCount: Int
    let title: String
    let links: CategoryLinks
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case photoCount = "photo_count"
        case links
    }
}


// MARK: - UserCollection
struct UserCollection: Codable {
}


// MARK: - CategoryLinks
struct CategoryLinks: Codable {
    let categoryLinks, photos: String
    
    enum CodingKeys: String, CodingKey {
        case categoryLinks = "self"
        case photos
    }
}


// MARK: - Links
struct Links: Codable {
    let linksSelf, html, download: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}
