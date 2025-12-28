//
//  SQLiteManager.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation
import SQLite3

let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

final class SQLiteManager {
    
    // MARK: - Properties
    static let shared = SQLiteManager()

    private let dbName = "inter_rapidisimo.sqlite"
    private var db: OpaquePointer?
    private let queue = DispatchQueue(label: "com.interrapidisimo.sqlite.queue")

    private init() {
        do {
            try openDatabase()
            try enableForeignKeys()
            try createTables()
        } catch {
            db = nil
        }
    }

    deinit {
        closeDatabaseSilently()
    }

    // MARK: - Helpers

    private var errorMessage: String {
        if let db, let error = sqlite3_errmsg(db) {
            return String(cString: error)
        }
        return "Unknown SQLite error"
    }

    private func databasePath() throws -> String {
        try FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(dbName)
            .path
    }

    private func ensureDB() throws {
        guard db != nil else {
            throw SQLiteError.openDatabase(message: "Database not initialized")
        }
    }

    private func openDatabase() throws {
        let path = try databasePath()
        if sqlite3_open(path, &db) != SQLITE_OK {
            throw SQLiteError.openDatabase(message: errorMessage)
        }
        sqlite3_busy_timeout(db, 5000)
    }

    private func closeDatabaseSilently() {
        if let db {
            sqlite3_close(db)
            self.db = nil
        }
    }

    private func enableForeignKeys() throws {
        try performExecute(sql: "PRAGMA foreign_keys = ON;")
    }

    private func createTables() throws {
        let tables = [
            """
            CREATE TABLE IF NOT EXISTS user(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                usuario TEXT NOT NULL,
                identificacion TEXT UNIQUE,
                nombre TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS schema_tables(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS photos(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                seq INTEGER NOT NULL,
                name TEXT NOT NULL,
                date TEXT NOT NULL,
                image BLOB NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """,
            """
            CREATE TABLE IF NOT EXISTS locality(
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL
            );
            """
        ]

        for sql in tables {
            try performExecute(sql: sql)
        }
    }
    
    private func performInsertWithBlob(
        sql: String,
        textBindings: [String],
        blob: Data
    ) async throws {

        try await queue.sync(flags: .barrier) {
            var stmt: OpaquePointer?
            guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
                throw SQLiteError.prepare(message: errorMessage)
            }
            defer { sqlite3_finalize(stmt) }

            for (index, value) in textBindings.enumerated() {
                sqlite3_bind_text(stmt, Int32(index + 1), value, -1, SQLITE_TRANSIENT)
            }

            blob.withUnsafeBytes {
                sqlite3_bind_blob(stmt, Int32(textBindings.count + 1), $0.baseAddress, Int32(blob.count), SQLITE_TRANSIENT)
            }

            guard sqlite3_step(stmt) == SQLITE_DONE else {
                throw SQLiteError.step(message: errorMessage)
            }
        }
    }


    // MARK: - Public API (async)

    func execute(_ sql: String) async throws {
        try await withCheckedThrowingContinuation { cont in
            queue.async {
                do {
                    try self.performExecute(sql: sql)
                    cont.resume()
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }

    func query<T>(_ sql: String, mapper: @escaping (OpaquePointer) throws -> T) async throws -> [T] {
        try await withCheckedThrowingContinuation { cont in
            queue.async {
                do {
                    let result = try self.performQuery(sql, mapper: mapper)
                    cont.resume(returning: result)
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }

    func performInTransaction(_ block: @escaping () throws -> Void) async throws {
        try await withCheckedThrowingContinuation { cont in
            queue.async {
                do {
                    try self.performExecute(sql: "BEGIN;")
                    do {
                        try block()
                        try self.performExecute(sql: "COMMIT;")
                        cont.resume()
                    } catch {
                        try? self.performExecute(sql: "ROLLBACK;")
                        cont.resume(throwing: error)
                    }
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Core

    private func performExecute(sql: String) throws {
        try ensureDB()
        var statement: OpaquePointer?
        defer {
            if let statement {
                sqlite3_finalize(statement)
            }
        }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }

        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw SQLiteError.step(message: errorMessage)
        }
    }

    private func performQuery<T>(_ sql: String,
                                 mapper: (OpaquePointer) throws -> T) throws -> [T] {
        try ensureDB()
        var statement: OpaquePointer?
        defer {
            if let statement {
                sqlite3_finalize(statement)
            }
        }

        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.prepare(message: errorMessage)
        }

        var results: [T] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            guard let stmt = statement else { continue }
            results.append(try mapper(stmt))
        }
        return results
    }
    
    func saveUser(_ user: User) async throws {
        let sql = """
        INSERT OR REPLACE INTO user (usuario, identificacion, nombre)
        VALUES ('\(user.user)', '\(user.id)', '\(user.name)');
        """
        try await execute(sql)
    }

    func fetchUser() async throws -> User? {
        let sql = "SELECT usuario, identificacion, nombre FROM user LIMIT 1;"
        
        let users = try await query(sql) { stmt in
            let user = String(cString: sqlite3_column_text(stmt, 0))
            let id = String(cString: sqlite3_column_text(stmt, 1))
            let name = String(cString: sqlite3_column_text(stmt, 2))
            return User(user: user, id: id, name: name)
        }
        
        return users.first
    }
    
    func saveLocalities(_ items: [Locality]) async throws {
        for loc in items {
            let sql = """
            INSERT OR REPLACE INTO locality (id, name)
            VALUES (\(loc.id), '\(loc.name)');
            """
            try await execute(sql)
        }
    }

    func fetchLocalities() async throws -> [Locality] {
        let sql = "SELECT id, name FROM locality ORDER BY name;"
        
        return try await query(sql) { stmt in
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            return Locality(id: id, name: name)
        }
    }
    
    func savePhoto(_ photo: Photo, seq: Int) async throws {
        let dateString = ISO8601DateFormatter().string(from: photo.date)

        let sql = """
        INSERT INTO photos (seq, name, date, image)
        VALUES (?, ?, ?, ?);
        """

        try await performInsertWithBlob(
            sql: sql,
            textBindings: [
                String(seq),
                photo.name,
                dateString
            ],
            blob: photo.imageData
        )
    }
    
    func fetchPhotos() async throws -> [Photo] {
        let sql = "SELECT id, name, date, image FROM photos ORDER BY seq DESC;"

        return try await query(sql) { stmt in
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let dateStr = String(cString: sqlite3_column_text(stmt, 2))
            let date = ISO8601DateFormatter().date(from: dateStr) ?? Date()

            let size = sqlite3_column_bytes(stmt, 3)
            let blob = sqlite3_column_blob(stmt, 3)
            let data = Data(bytes: blob!, count: Int(size))

            return Photo(id: id, name: name, date: date, imageData: data)
        }
    }
    
    func nextPhotoSequence() async throws -> Int {
        let sql = "SELECT IFNULL(MAX(seq), 0) + 1 FROM photos;"

        let result = try await query(sql) { stmt in
            Int(sqlite3_column_int(stmt, 0))
        }

        return result.first ?? 1
    }
    
    func deleteUser() async throws {
        let sql = "DELETE FROM user;"
        try await execute(sql)
    }
}
