//
//  GameModel.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import Foundation

class GameModel {
    let id: Int
    let title: String
    let rating: Double
    let releaseDate: String
    let imageUrl: String
    
    init(
        id: Int,
        title: String,
        rating: Double,
        releaseDate: String,
        imageUrl: String
    ) {
        self.id = id
        self.title = title
        self.rating = rating
        self.releaseDate = releaseDate
        self.imageUrl = imageUrl
    }
}
