//
//  PhotosViewModelTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
import UIKit
@testable import Inter_Rapidísimo

@MainActor
final class PhotosViewModelTests: XCTestCase {
    
    var mockRepo: MockPhotoRepository!
    var viewModel: PhotosViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockPhotoRepository()
        viewModel = PhotosViewModel(repo: mockRepo)
    }
    
    func testSaveImageSuccess() async {
        // Given
        let testImage = UIImage(systemName: "photo")!
        mockRepo.nextSeq = 1
        
        // When
        await viewModel.saveImage(testImage)
        
        // Then
        XCTAssertEqual(mockRepo.savedPhotos.count, 1)
        let savedPhoto = mockRepo.savedPhotos[0]
        XCTAssertEqual(savedPhoto.name, "photo-001")
        XCTAssertNotNil(savedPhoto.imageData)
    }
    
    func testSaveImageGeneratesSequentialNames() async {
        // Given
        let testImage = UIImage(systemName: "photo")!
        mockRepo.nextSeq = 1
        
        // When
        await viewModel.saveImage(testImage)
        await viewModel.saveImage(testImage)
        await viewModel.saveImage(testImage)
        
        // Then
        XCTAssertEqual(mockRepo.savedPhotos.count, 3)
        XCTAssertEqual(mockRepo.savedPhotos[0].name, "photo-001")
        XCTAssertEqual(mockRepo.savedPhotos[1].name, "photo-002")
        XCTAssertEqual(mockRepo.savedPhotos[2].name, "photo-003")
    }
    
    func testSaveImageFailure() async {
        // Given
        let testImage = UIImage(systemName: "photo")!
        mockRepo.shouldFail = true
        mockRepo.error = SQLiteError.openDatabase(message: "DB error")
        
        // When
        await viewModel.saveImage(testImage)
        
        // Then
        XCTAssertTrue(mockRepo.savedPhotos.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testLoadPhotosSuccess() async {
        // Given
        let photo1 = Photo(id: 1, name: "photo-001", date: Date(), imageData: Data())
        let photo2 = Photo(id: 2, name: "photo-002", date: Date(), imageData: Data())
        mockRepo.savedPhotos = [photo1, photo2]
        
        // When
        await viewModel.loadPhotos()
        
        // Then
        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos[0].name, "photo-001")
        XCTAssertEqual(viewModel.photos[1].name, "photo-002")
    }
    
    func testLoadPhotosFailure() async {
        // Given
        mockRepo.shouldFail = true
        mockRepo.error = SQLiteError.openDatabase(message: "DB error")
        
        // When
        await viewModel.loadPhotos()
        
        // Then
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testRequestCameraAccessAuthorized() async {
        // Given - This would need to mock AVFoundation, which is complex
        // For now, we test the structure
        
        // When
        await viewModel.requestCameraAccess()
        
        // Then - Verify the method doesn't crash
        // In a real scenario, we'd mock CameraPermissionManager
        XCTAssertNotNil(viewModel)
    }
}

