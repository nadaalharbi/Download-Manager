//
//  UsersModel.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import Foundation


// To parse the JSON, add this file to your project and do:
//
//   let elmUser = try? newJSONDecoder().decode(ElmUser.self, from: jsonData)


typealias Response = [UserModel]
//
//struct ElmUsers: Codable {
//    let UserComponent: [UserComponent]
//}

// MARK: - UserModel
struct UserModel: Codable {
    let id, color: String
    let width, height, likes: Int
    let likedByUser: Bool
    let createdAt: String// Date
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
    
   
}// end of UserComponent

// MARK: - User
struct User: Codable {
    let id, username, name: String
    let profileImage: ProfileImage
    let links: UserLinks
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, links
        case profileImage = "profile_image"
    }
}// end of User


// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}// end of ProfileImage

// MARK: - UserLinks
struct UserLinks: Codable {
    let userLinksSelf, html, photos, likes: String
    
    enum CodingKeys: String, CodingKey {
        case userLinksSelf = "self"
        case html, photos, likes
    }
}// end of UserLinks

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small, thumb: String

    // Todo remove it no need
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}// end of Urls

// MARK: - Category
struct Category: Codable {
    let id, photoCount: Int
    let title: String//Title
    let links: CategoryLinks

    enum CodingKeys: String, CodingKey {
        case id, title
        case photoCount = "photo_count"
        case links
    }
}// end of Category

struct UserCollection: Codable {
}

// MARK: - CategoryLinks
struct CategoryLinks: Codable {
    let categoryLinks, photos: String

    enum CodingKeys: String, CodingKey {
        case categoryLinks = "self"
        case photos
    }
}// end of CategoryLinks

// MARK: - Links
struct Links: Codable {
    let linksSelf, html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}// end of Links
