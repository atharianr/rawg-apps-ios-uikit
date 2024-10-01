//
//  FavoriteTable.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 01/10/24.
//

import SQLite

class FavoriteTable {

    // Increment 'dbVersion' if adding new column in table
    static let shared = FavoriteTable(dbConnection: DatabaseManager(dbVersion: 2).getDb())

    private let gamesTable = Table("games")
    private let gameId = Expression<Int>("gameId")
    private let gameTitle = Expression<String>("gameTitle")
    private let gameRating = Expression<Double>("gameRating")
    private let gameReleaseDate = Expression<String>("gameReleaseDate")
    private let gameImageUrl = Expression<String>("gameImageUrl")

    private var dbConnection: Connection

    init(dbConnection: Connection) {
        self.dbConnection = dbConnection
        do {
            try dbConnection.run(
                gamesTable.create(ifNotExists: true) { table in
                    table.column(gameId, primaryKey: true)
                    table.column(gameTitle, defaultValue: "")
                    table.column(gameRating, defaultValue: 0.0)
                    table.column(gameReleaseDate, defaultValue: "")
                    table.column(gameImageUrl, defaultValue: "")
                }
            )
        } catch {
            debugPrint("Error creating table: \(error)")
        }
    }

    func insert(game: GameModel) async -> Int64 {
        do {
            let insert = gamesTable.insert(
                self.gameId <- game.id,
                self.gameTitle <- game.title,
                self.gameRating <- game.rating,
                self.gameReleaseDate <- game.releaseDate,
                self.gameImageUrl <- game.releaseDate
            )
            let gameId = try dbConnection.run(insert)

            return gameId
        } catch {
            debugPrint("Failed to insert game: \(error)")
            return 0
        }
    }

    func delete(gameId: Int) async -> Bool {
        do {
            let query = gamesTable.filter(self.gameId == gameId)
            let deleteCount = try dbConnection.run(query.delete())

            return deleteCount > 0
        } catch {
            debugPrint("Failed to delete game: \(error)")
            return false
        }
    }

    func exists(gameId: Int) async -> Bool {
        do {
            let query = gamesTable.filter(self.gameId == gameId)
            let queryCount = try dbConnection.scalar(query.count)

            return queryCount > 0
        } catch {
            debugPrint("Failed to check existence of gameId \(gameId): \(error)")
            return false
        }
    }

    func getAll() async -> [GameModel] {
        var games: [GameModel] = []

        do {
            for row in try dbConnection.prepare(gamesTable) {
                let game = GameModel(
                    id: row[self.gameId],
                    title: row[self.gameTitle],
                    rating: row[self.gameRating],
                    releaseDate: row[self.gameReleaseDate],
                    imageUrl: row[self.gameImageUrl]
                )
                games.append(game)
            }
        } catch {
            debugPrint("Failed to fetch games: \(error)")
        }

        return games
    }

}
