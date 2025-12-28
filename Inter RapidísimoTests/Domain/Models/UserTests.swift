//
//  UserTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class UserTests: XCTestCase {
    
    func testUserInitialization() {
        // Given & When
        let user = User(user: "test.user", id: "123456789", name: "Test User")
        
        // Then
        XCTAssertEqual(user.user, "test.user")
        XCTAssertEqual(user.id, "123456789")
        XCTAssertEqual(user.name, "Test User")
    }
    
    func testUserEquality() {
        // Given
        let user1 = User(user: "test.user", id: "123456789", name: "Test User")
        let user2 = User(user: "test.user", id: "123456789", name: "Test User")
        let user3 = User(user: "other.user", id: "987654321", name: "Other User")
        
        // Then
        XCTAssertEqual(user1.user, user2.user)
        XCTAssertEqual(user1.id, user2.id)
        XCTAssertEqual(user1.name, user2.name)
        XCTAssertNotEqual(user1.user, user3.user)
    }
}

