//
//  GameDetailResponse.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 26/09/24.
//

import Foundation

// MARK: - GameDetailResponse
struct GameDetailResponse: Codable {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage, backgroundImageAdditional: String?
    let rating: Double?
    let ratingTop: Int?
    let platforms: [PlatformElement]?
    let publishers: [Developer]?
    let esrbRating: EsrbRating?
    let descriptionRaw: String?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case rating
        case ratingTop = "rating_top"
        case platforms, publishers
        case esrbRating = "esrb_rating"
        case descriptionRaw = "description_raw"
    }
}

// MARK: - Developer
struct Developer: Codable {
    let name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
