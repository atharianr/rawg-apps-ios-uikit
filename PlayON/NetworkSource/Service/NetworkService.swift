//
//  NetworkService.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import Foundation
import Alamofire

class NetworkService {
    private let baseUrl = "https://api.rawg.io/api/"
    private let apiKey = "bed6f0e5ab8f4c79ae81100b9da09f04"

    func getGameList(completion: @escaping ([GameModel]) -> Void) {
        let url = "\(baseUrl)games"
        let parameters: [String: String] = [
            "key": apiKey,
            "page_size": "10",
            "page": "1"
        ]

        AF.request(url, parameters: parameters).responseDecodable(of: GameListResponse.self) { response in
            switch response.result {
            case .success(let gameList):
                let gameModels = gameList.results.map { result in
                    GameModel(
                        id: result.id,
                        title: result.name,
                        rating: result.rating,
                        releaseDate: result.released,
                        imageUrl: result.backgroundImage
                    )
                }
                completion(gameModels)
            case .failure(let error):
                debugPrint("Error fetching games: \(error)")
                completion([])  // Return an empty array on failure
            }
        }
    }

    func getGameDetail(id: Int, completion: @escaping (GameDetailModel?) -> Void) {
        let url = "\(baseUrl)games/\(id)"
        let parameters: [String: String] = ["key": apiKey]

        AF.request(url, parameters: parameters).responseDecodable(of: GameDetailResponse.self) { response in
            switch response.result {
            case .success(let gameDetailResponse):
                let publisher = gameDetailResponse.publishers.map { $0.name }.joined(separator: ", ")
                let platforms = gameDetailResponse.platforms.map { $0.platform.name }.joined(separator: ", ")

                let gameModel = GameDetailModel(
                    id: gameDetailResponse.id,
                    title: gameDetailResponse.name,
                    rating: gameDetailResponse.rating,
                    ratingTop: gameDetailResponse.ratingTop,
                    releaseDate: gameDetailResponse.released,
                    esrbRating: gameDetailResponse.esrbRating.name,
                    imageUrl: gameDetailResponse.backgroundImage,
                    imageAdditionalUrl: gameDetailResponse.backgroundImageAdditional,
                    publisher: publisher,
                    platform: platforms,
                    description: gameDetailResponse.descriptionRaw
                )
                completion(gameModel)
            case .failure(let error):
                debugPrint("Error fetching games: \(error)")
                completion(nil)
            }
        }
    }
}
