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
                if let results = gameList.results {
                    let gameModels = results.map { result in
                        GameModel(
                            id: result.id ?? 0,
                            title: result.name ?? "-",
                            rating: result.rating ?? 0.0,
                            releaseDate: result.released ?? "-",
                            imageUrl: result.backgroundImage ?? ""
                        )
                    }
                    completion(gameModels)
                } else {
                    completion([])
                }
            case .failure(let error):
                debugPrint("Error fetching games: \(error)")
                completion([])
            }
        }
    }

    func getSearchGameList(query: String, completion: @escaping ([GameModel]) -> Void) {
        let url = "\(baseUrl)games"
        let parameters: [String: String] = [
            "key": apiKey,
            "search": query
        ]

        AF.request(url, parameters: parameters).responseDecodable(of: GameListResponse.self) { response in
            switch response.result {
            case .success(let gameList):
                if let results = gameList.results {
                    let gameModels = results.map { result in
                        GameModel(
                            id: result.id ?? 0,
                            title: result.name ?? "-",
                            rating: result.rating ?? 0.0,
                            releaseDate: result.released ?? "-",
                            imageUrl: result.backgroundImage ?? ""
                        )
                    }
                    completion(gameModels)
                } else {
                    completion([])
                }
            case .failure(let error):
                debugPrint("Error fetching games: \(error)")
                completion([])
            }
        }
    }

    func getGameDetail(id: Int, completion: @escaping (GameDetailModel?) -> Void) {
        let url = "\(baseUrl)games/\(id)"
        let parameters: [String: String] = ["key": apiKey]

        AF.request(url, parameters: parameters).responseDecodable(of: GameDetailResponse.self) { response in
            switch response.result {
            case .success(let gameDetailResponse):
                let publisher = gameDetailResponse.publishers?.map { $0.name ?? "" }.joined(separator: ", ") ?? "-"
                let platforms = gameDetailResponse.platforms?.map {
                    $0.platform?.name ?? ""
                }.joined(separator: ", ") ?? "-"

                let gameModel = GameDetailModel(
                    id: gameDetailResponse.id ?? 0,
                    title: gameDetailResponse.name ?? "-",
                    rating: gameDetailResponse.rating ?? 0.0,
                    ratingTop: gameDetailResponse.ratingTop ?? 0,
                    releaseDate: gameDetailResponse.released ?? "-",
                    esrbRating: gameDetailResponse.esrbRating?.name ?? "-",
                    imageUrl: gameDetailResponse.backgroundImage ??
                    gameDetailResponse.backgroundImageAdditional ?? "",
                    imageAdditionalUrl: gameDetailResponse.backgroundImageAdditional ??
                    gameDetailResponse.backgroundImage ?? "",
                    publisher: publisher,
                    platform: platforms,
                    description: gameDetailResponse.descriptionRaw ?? "-"
                )
                completion(gameModel)
            case .failure(let error):
                debugPrint("Error fetching games: \(error)")
                completion(nil)
            }
        }
    }
}
