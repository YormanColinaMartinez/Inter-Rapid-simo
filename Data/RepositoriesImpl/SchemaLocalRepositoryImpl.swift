//
//  SchemaLocalRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation
import SQLite3

final class SchemaLocalRepositoryImpl {

    private let db = SQLiteManager.shared

    func saveAll(_ tables: [SchemaTableDTO]) async throws {
        try await db.execute("DELETE FROM schema_tables;")

        for table in tables {
            let sql = """
            INSERT INTO schema_tables (nombre_tabla, descripcion)
            VALUES ('\(table.nombreTabla)', '\(table.descripcion ?? "")');
            """
            try await db.execute(sql)
        }
    }

    func getAll() async throws -> [SchemaTableDTO] {
        let sql = "SELECT nombre_tabla, descripcion FROM schema_tables;"

        return try await db.query(sql) { stmt in
            let nombre = String(cString: sqlite3_column_text(stmt, 0))
            let descripcion = sqlite3_column_text(stmt, 1).map { String(cString: $0) }
            return SchemaTableDTO(nombreTabla: nombre, descripcion: descripcion)
        }
    }
}
