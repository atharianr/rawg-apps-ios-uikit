//
//  DatabaseService.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 01/10/24.
//

import Foundation

class DatabaseService {

    private var favoriteTable = FavoriteTable.shared

    func addFavorite(_ game: GameModel) async -> Int64 {
        return await favoriteTable.insert(game: game)
    }

    func deleteFavorite(_ id: Int) async -> Bool {
        return await favoriteTable.delete(gameId: id)
    }

    func isAlreadyFavorite(_ id: Int) async -> Bool {
        return await favoriteTable.exists(gameId: id)
    }

    func getAllFavorites() async -> [GameModel] {
        return await favoriteTable.getAll()
    }
}
