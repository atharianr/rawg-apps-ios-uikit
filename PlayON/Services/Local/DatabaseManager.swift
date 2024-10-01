//
//  DatabaseManager.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 01/10/24.
//

import Foundation
import SQLite

class DatabaseManager {

    private let dbConnection: Connection

    private var dbVersion: Int

    init(dbVersion: Int) {
        self.dbVersion = dbVersion

        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        ).first!

        debugPrint("DB Connection Location: \(path)/GameDatabase_\(dbVersion).db")

        do {
            dbConnection = try Connection("\(path)/GameDatabase_\(dbVersion).db")
        } catch {
            debugPrint("Failed to create database connection: \(error)")
            fatalError("Database connection failed. Exiting.")
        }
    }

    func getDb() -> Connection {
        return dbConnection
    }
}
