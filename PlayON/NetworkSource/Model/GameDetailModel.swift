//
//  GameModel.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import Foundation

class GameDetailModel {
    let id: Int
    let title: String
    let rating: Double
    let ratingTop: Int
    let releaseDate: String
    let esrbRating: String
    let imageUrl: String
    let imageAdditionalUrl: String
    let publisher: String
    let platform: String
    let description: String
    
    init(
        id: Int,
        title: String,
        rating: Double,
        ratingTop: Int,
        releaseDate: String,
        esrbRating: String,
        imageUrl: String,
        imageAdditionalUrl: String,
        publisher: String,
        platform: String,
        description: String
    ) {
        self.id = id
        self.title = title
        self.rating = rating
        self.ratingTop = ratingTop
        self.releaseDate = releaseDate
        self.esrbRating = esrbRating
        self.imageUrl = imageUrl
        self.imageAdditionalUrl = imageAdditionalUrl
        self.publisher = publisher
        self.platform = platform
        self.description = description
    }
}
