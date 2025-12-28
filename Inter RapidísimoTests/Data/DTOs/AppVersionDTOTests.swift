//
//  AppVersionDTOTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class AppVersionDTOTests: XCTestCase {
    
    func testAppVersionDTOInitialization() {
        // Given & When
        let dto = AppVersionDTO(version: "1.0")
        
        // Then
        XCTAssertEqual(dto.version, "1.0")
    }
    
    func testAppVersionDTOWithDifferentVersions() {
        // Given & When
        let dto1 = AppVersionDTO(version: "1.0")
        let dto2 = AppVersionDTO(version: "2.5.3")
        let dto3 = AppVersionDTO(version: "100")
        
        // Then
        XCTAssertEqual(dto1.version, "1.0")
        XCTAssertEqual(dto2.version, "2.5.3")
        XCTAssertEqual(dto3.version, "100")
    }
}

