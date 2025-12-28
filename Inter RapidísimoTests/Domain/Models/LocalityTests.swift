//
//  LocalityTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class LocalityTests: XCTestCase {
    
    func testLocalityInitialization() {
        // Given & When
        let locality = Locality(id: 1, abreviacionCiudad: "BOG", nombreCompleto: "Bogotá D.C.")
        
        // Then
        XCTAssertEqual(locality.id, 1)
        XCTAssertEqual(locality.abreviacionCiudad, "BOG")
        XCTAssertEqual(locality.nombreCompleto, "Bogotá D.C.")
        XCTAssertEqual(locality.name, "Bogotá D.C.")
    }
    
    func testLocalityNameProperty() {
        // Given
        let locality = Locality(id: 1, abreviacionCiudad: "MED", nombreCompleto: "Medellín")
        
        // Then
        XCTAssertEqual(locality.name, locality.nombreCompleto)
    }
    
    func testLocalityIdentifiable() {
        // Given
        let locality1 = Locality(id: 1, abreviacionCiudad: "BOG", nombreCompleto: "Bogotá")
        let locality2 = Locality(id: 2, abreviacionCiudad: "MED", nombreCompleto: "Medellín")
        
        // Then
        XCTAssertNotEqual(locality1.id, locality2.id)
    }
}

