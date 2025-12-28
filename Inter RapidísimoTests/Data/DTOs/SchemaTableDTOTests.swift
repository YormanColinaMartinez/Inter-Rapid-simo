//
//  SchemaTableDTOTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class SchemaTableDTOTests: XCTestCase {
    
    func testDecodeSchemaTableSuccess() throws {
        // Given
        let json = """
        {
            "NombreTabla": "users",
            "Descripcion": "Tabla de usuarios"
        }
        """.data(using: .utf8)!
        
        // When
        let dto = try JSONDecoder().decode(SchemaTableDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.nombreTabla, "users")
        XCTAssertEqual(dto.descripcion, "Tabla de usuarios")
    }
    
    func testDecodeSchemaTableWithNullDescription() throws {
        // Given
        let json = """
        {
            "NombreTabla": "users",
            "Descripcion": null
        }
        """.data(using: .utf8)!
        
        // When
        let dto = try JSONDecoder().decode(SchemaTableDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.nombreTabla, "users")
        XCTAssertNil(dto.descripcion)
    }
    
    func testDecodeSchemaTableArray() throws {
        // Given
        let json = """
        [
            {
                "NombreTabla": "users",
                "Descripcion": "Tabla de usuarios"
            },
            {
                "NombreTabla": "orders",
                "Descripcion": "Tabla de órdenes"
            }
        ]
        """.data(using: .utf8)!
        
        // When
        let dtos = try JSONDecoder().decode([SchemaTableDTO].self, from: json)
        
        // Then
        XCTAssertEqual(dtos.count, 2)
        XCTAssertEqual(dtos[0].nombreTabla, "users")
        XCTAssertEqual(dtos[1].nombreTabla, "orders")
    }
}

