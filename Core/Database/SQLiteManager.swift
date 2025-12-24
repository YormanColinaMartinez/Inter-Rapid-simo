//
//  SQLiteManager.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation
import SQLite3

final class SQLiteManager {
    
    // MARK: - Properties
    static let shared = SQLiteManager()

    private let dbName = "inter_rapidisimo.sqlite"
    private var db: OpaquePointer?
    private let queue = DispatchQueue(label: "com.interrapidisimo.sqlite.queue")

    private init() {
        do {
            #if DEBUG
            print("📁 DB Path: \(try databasePath())")
            #endif
            try openDatabase()
            try enableForeignKeys()
            try createTables()
        } catch {
            #if DEBUG
            print(" SQLite init failed: \(error.localizedDescription)")
            #endif
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
                image BLOB,
                user_id INTEGER,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
            );
            """
        ]

        for sql in tables {
            try performExecute(sql: sql)
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
}
