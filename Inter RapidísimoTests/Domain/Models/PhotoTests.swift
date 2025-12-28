//
//  PhotoTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
import UIKit
@testable import Inter_Rapidísimo

final class PhotoTests: XCTestCase {
    
    func testPhotoInitialization() {
        // Given
        let imageData = Data([1, 2, 3, 4])
        let date = Date()
        
        // When
        let photo = Photo(id: 1, name: "photo-001", date: date, imageData: imageData)
        
        // Then
        XCTAssertEqual(photo.id, 1)
        XCTAssertEqual(photo.name, "photo-001")
        XCTAssertEqual(photo.date, date)
        XCTAssertEqual(photo.imageData, imageData)
    }
    
    func testPhotoIdentifiable() {
        // Given
        let photo1 = Photo(id: 1, name: "photo-001", date: Date(), imageData: Data())
        let photo2 = Photo(id: 2, name: "photo-002", date: Date(), imageData: Data())
        
        // Then
        XCTAssertNotEqual(photo1.id, photo2.id)
    }
    
    func testPhotoWithNilId() {
        // Given
        let photo = Photo(id: nil, name: "photo-001", date: Date(), imageData: Data())
        
        // Then
        XCTAssertNil(photo.id)
        XCTAssertEqual(photo.name, "photo-001")
    }
}

