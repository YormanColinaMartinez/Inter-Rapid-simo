//
//  LocalityDTOTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class LocalityDTOTests: XCTestCase {
    
    func testDecodeLocalitySuccess() throws {
        // Given
        let json = """
        {
            "AbreviacionCiudad": "BOG",
            "NombreCompleto": "Bogotá D.C."
        }
        """.data(using: .utf8)!
        
        // When
        let dto = try JSONDecoder().decode(LocalityDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.abreviacionCiudad, "BOG")
        XCTAssertEqual(dto.nombreCompleto, "Bogotá D.C.")
    }
    
    func testDecodeLocalityArray() throws {
        // Given
        let json = """
        [
            {
                "AbreviacionCiudad": "BOG",
                "NombreCompleto": "Bogotá D.C."
            },
            {
                "AbreviacionCiudad": "MED",
                "NombreCompleto": "Medellín"
            }
        ]
        """.data(using: .utf8)!
        
        // When
        let dtos = try JSONDecoder().decode([LocalityDTO].self, from: json)
        
        // Then
        XCTAssertEqual(dtos.count, 2)
        XCTAssertEqual(dtos[0].abreviacionCiudad, "BOG")
        XCTAssertEqual(dtos[1].abreviacionCiudad, "MED")
    }
}

