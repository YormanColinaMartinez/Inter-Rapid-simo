//
//  SQLiteManagerTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 28/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

final class SQLiteManagerTests: XCTestCase {
    
    var dbManager: SQLiteManager!
    var testDBPath: String!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create a test database path
        let testDir = FileManager.default.temporaryDirectory
        testDBPath = testDir.appendingPathComponent("test_inter_rapidisimo.sqlite").path
        
        // Remove test database if it exists
        if FileManager.default.fileExists(atPath: testDBPath) {
            try? FileManager.default.removeItem(atPath: testDBPath)
        }
    }
    
    override func tearDown() async throws {
        // Clean up test database
        if let testDBPath = testDBPath,
           FileManager.default.fileExists(atPath: testDBPath) {
            try? FileManager.default.removeItem(atPath: testDBPath)
        }
        try await super.tearDown()
    }
    
    // MARK: - User Tests
    
    func testSaveAndFetchUser() async throws {
        let user = User(user: "test.user", id: "123456789", name: "Test User")
        
        try await SQLiteManager.shared.saveUser(user)
        let fetchedUser = try await SQLiteManager.shared.fetchUser()
        
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.user, user.user)
        XCTAssertEqual(fetchedUser?.id, user.id)
        XCTAssertEqual(fetchedUser?.name, user.name)
    }
    
    func testSaveUserWithSpecialCharacters() async throws {
        let user = User(user: "test'user", id: "123'456", name: "Test'Name")
        
        try await SQLiteManager.shared.saveUser(user)
        let fetchedUser = try await SQLiteManager.shared.fetchUser()
        
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(fetchedUser?.user, user.user)
        XCTAssertEqual(fetchedUser?.id, user.id)
        XCTAssertEqual(fetchedUser?.name, user.name)
    }
    
    func testDeleteUser() async throws {
        let user = User(user: "test.user", id: "123456789", name: "Test User")
        
        try await SQLiteManager.shared.saveUser(user)
        try await SQLiteManager.shared.deleteUser()
        
        let fetchedUser = try await SQLiteManager.shared.fetchUser()
        XCTAssertNil(fetchedUser)
    }
    
    // MARK: - Photos Tests
    
    func testSaveAndFetchPhoto() async throws {
        let testImage = createTestImage()
        guard let imageData = testImage.jpegData(compressionQuality: 0.8) else {
            XCTFail("Failed to create image data")
            return
        }
        
        let photo = Photo(id: 0, name: "photo-001", date: Date(), imageData: imageData)
        let seq = try await SQLiteManager.shared.nextPhotoSequence()
        
        try await SQLiteManager.shared.savePhoto(photo, seq: seq)
        let photos = try await SQLiteManager.shared.fetchPhotos()
        
        XCTAssertFalse(photos.isEmpty)
        XCTAssertEqual(photos.first?.name, "photo-001")
        XCTAssertEqual(photos.first?.imageData.count, imageData.count)
    }
    
    func testNextPhotoSequence() async throws {
        let firstSeq = try await SQLiteManager.shared.nextPhotoSequence()
        XCTAssertEqual(firstSeq, 1)
        
        let testImage = createTestImage()
        guard let imageData = testImage.jpegData(compressionQuality: 0.8) else {
            XCTFail("Failed to create image data")
            return
        }
        
        let photo1 = Photo(id: 0, name: "photo-001", date: Date(), imageData: imageData)
        try await SQLiteManager.shared.savePhoto(photo1, seq: 1)
        
        let secondSeq = try await SQLiteManager.shared.nextPhotoSequence()
        XCTAssertEqual(secondSeq, 2)
        
        let photo2 = Photo(id: 0, name: "photo-002", date: Date(), imageData: imageData)
        try await SQLiteManager.shared.savePhoto(photo2, seq: 2)
        
        let thirdSeq = try await SQLiteManager.shared.nextPhotoSequence()
        XCTAssertEqual(thirdSeq, 3)
    }
    
    func testFetchPhotosOrderedBySequence() async throws {
        let testImage = createTestImage()
        guard let imageData = testImage.jpegData(compressionQuality: 0.8) else {
            XCTFail("Failed to create image data")
            return
        }
        
        let photo1 = Photo(id: 0, name: "photo-001", date: Date(), imageData: imageData)
        let photo2 = Photo(id: 0, name: "photo-002", date: Date(), imageData: imageData)
        let photo3 = Photo(id: 0, name: "photo-003", date: Date(), imageData: imageData)
        
        try await SQLiteManager.shared.savePhoto(photo1, seq: 1)
        try await SQLiteManager.shared.savePhoto(photo2, seq: 2)
        try await SQLiteManager.shared.savePhoto(photo3, seq: 3)
        
        let photos = try await SQLiteManager.shared.fetchPhotos()
        
        XCTAssertEqual(photos.count, 3)
        XCTAssertEqual(photos[0].name, "photo-003") // Should be ordered DESC
        XCTAssertEqual(photos[1].name, "photo-002")
        XCTAssertEqual(photos[2].name, "photo-001")
    }
    
    // MARK: - Localities Tests
    
    func testSaveAndFetchLocalities() async throws {
        let localities = [
            Locality(id: 1, abreviacionCiudad: "BOG", nombreCompleto: "Bogotá"),
            Locality(id: 2, abreviacionCiudad: "MED", nombreCompleto: "Medellín"),
            Locality(id: 3, abreviacionCiudad: "CAL", nombreCompleto: "Cali")
        ]
        
        try await SQLiteManager.shared.saveLocalities(localities)
        let fetchedLocalities = try await SQLiteManager.shared.fetchLocalities()
        
        XCTAssertEqual(fetchedLocalities.count, 3)
        XCTAssertEqual(fetchedLocalities[0].abreviacionCiudad, "BOG")
        XCTAssertEqual(fetchedLocalities[0].nombreCompleto, "Bogotá")
    }
    
    func testSaveLocalitiesReplacesExisting() async throws {
        let localities1 = [
            Locality(id: 1, abreviacionCiudad: "BOG", nombreCompleto: "Bogotá")
        ]
        
        let localities2 = [
            Locality(id: 1, abreviacionCiudad: "MED", nombreCompleto: "Medellín")
        ]
        
        try await SQLiteManager.shared.saveLocalities(localities1)
        try await SQLiteManager.shared.saveLocalities(localities2)
        
        let fetchedLocalities = try await SQLiteManager.shared.fetchLocalities()
        
        XCTAssertEqual(fetchedLocalities.count, 1)
        XCTAssertEqual(fetchedLocalities[0].abreviacionCiudad, "MED")
    }
    
    func testSaveLocalitiesWithSpecialCharacters() async throws {
        let localities = [
            Locality(id: 1, abreviacionCiudad: "BOG'", nombreCompleto: "Bogotá' D.C.")
        ]
        
        try await SQLiteManager.shared.saveLocalities(localities)
        let fetchedLocalities = try await SQLiteManager.shared.fetchLocalities()
        
        XCTAssertEqual(fetchedLocalities.count, 1)
        XCTAssertEqual(fetchedLocalities[0].abreviacionCiudad, "BOG'")
        XCTAssertEqual(fetchedLocalities[0].nombreCompleto, "Bogotá' D.C.")
    }
    
    // MARK: - Helper Methods
    
    private func createTestImage() -> UIImage {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

