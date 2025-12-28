//
//  LoginResponseDTOTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class LoginResponseDTOTests: XCTestCase {
    
    func testDecodeLoginResponseSuccess() throws {
        // Given
        let json = """
        {
            "Usuario": "test.user",
            "Identificacion": "123456789",
            "Nombre": "Test",
            "Apellido1": "User",
            "Apellido2": "Last",
            "Cargo": "Developer",
            "MensajeResultado": 200,
            "TokenJWT": "mock-token"
        }
        """.data(using: .utf8)!
        
        // When
        let dto = try JSONDecoder().decode(LoginResponseDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.username, "test.user")
        XCTAssertEqual(dto.identification, "123456789")
        XCTAssertEqual(dto.firstName, "Test")
        XCTAssertEqual(dto.lastName1, "User")
        XCTAssertEqual(dto.lastName2, "Last")
        XCTAssertEqual(dto.role, "Developer")
        XCTAssertEqual(dto.resultMessage, 200)
        XCTAssertEqual(dto.token, "mock-token")
    }
    
    func testDecodeLoginResponseWithNulls() throws {
        // Given
        let json = """
        {
            "Usuario": "test.user",
            "Identificacion": null,
            "Nombre": null,
            "Apellido1": null,
            "Apellido2": null,
            "Cargo": null,
            "MensajeResultado": 200,
            "TokenJWT": null
        }
        """.data(using: .utf8)!
        
        // When
        let dto = try JSONDecoder().decode(LoginResponseDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.username, "test.user")
        XCTAssertNil(dto.identification)
        XCTAssertNil(dto.firstName)
        XCTAssertNil(dto.lastName1)
        XCTAssertNil(dto.lastName2)
        XCTAssertNil(dto.role)
        XCTAssertEqual(dto.resultMessage, 200)
        XCTAssertNil(dto.token)
    }
    
    func testDecodeLoginResponseMinimal() throws {
        // Given
        let json = """
        {
            "Usuario": "test.user",
            "MensajeResultado": 200
        }
        """.data(using: .utf8)!
        
        // When
        let dto = try JSONDecoder().decode(LoginResponseDTO.self, from: json)
        
        // Then
        XCTAssertEqual(dto.username, "test.user")
        XCTAssertEqual(dto.resultMessage, 200)
    }
}

