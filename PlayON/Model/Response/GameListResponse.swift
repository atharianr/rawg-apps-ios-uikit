//
//  NetworkService.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import Foundation

// MARK: - GameListResponse
struct GameListResponse: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let name, released: String?
    let backgroundImage: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
    }
}

// MARK: - EsrbRating
struct EsrbRating: Codable {
    let id: Int?
    let name, slug: String?
}

// MARK: - PlatformElement
struct PlatformElement: Codable {
    let platform: PlatformPlatform?
}

// MARK: - PlatformPlatform
struct PlatformPlatform: Codable {
    let name: String?
}
