//
//  UserRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation
import SQLite3

final class UserRepositoryImpl: UserRepository {

    private let db = SQLiteManager.shared

    func save(user: User) async throws {
        try await deleteAll()

        let sql = """
        INSERT INTO user (usuario, identificacion, nombre)
        VALUES ('\(user.user)', '\(user.id)', '\(user.name)');
        """
        try await db.execute(sql)
    }

    func getUser() async throws -> User? {
        let sql = "SELECT user, id, name FROM user LIMIT 1;"

        let users = try await db.query(sql) { stmt in
            let user = String(cString: sqlite3_column_text(stmt, 0))
            let id = String(cString: sqlite3_column_text(stmt, 1))
            let name = String(cString: sqlite3_column_text(stmt, 2))
            return User(user: user, id: id, name: name)
        }
        return users.first
    }

    func deleteAll() async throws {
        try await db.execute("DELETE FROM user;")
    }
}
