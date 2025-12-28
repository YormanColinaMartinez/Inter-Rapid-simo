//
//  LocalitiesViewModelTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

@MainActor
final class LocalitiesViewModelTests: XCTestCase {
    
    var mockRepo: MockLocalitiesRepository!
    var viewModel: LocalitiesViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockLocalitiesRepository()
        viewModel = LocalitiesViewModel(repo: mockRepo)
    }
    
    func testLoadLocalitiesSuccess() {
        // Given
        let mockLocalities = [
            Locality(id: 1, abreviacionCiudad: "BOG", nombreCompleto: "Bogotá"),
            Locality(id: 2, abreviacionCiudad: "MED", nombreCompleto: "Medellín")
        ]
        mockRepo.mockLocalities = mockLocalities
        let expectation = expectation(description: "Load completes")
        
        // When
        viewModel.load()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.error)
            XCTAssertEqual(self.viewModel.items.count, 2)
            XCTAssertEqual(self.viewModel.items[0].nombreCompleto, "Bogotá")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadLocalitiesRemoteFailureUsesLocal() {
        // Given
        let mockLocalities = [
            Locality(id: 1, abreviacionCiudad: "BOG", nombreCompleto: "Bogotá")
        ]
        mockRepo.shouldFailRemote = true
        mockRepo.mockLocalities = mockLocalities
        let expectation = expectation(description: "Load completes with local data")
        
        // When
        viewModel.load()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.items.count, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadLocalitiesBothFail() {
        // Given
        mockRepo.shouldFailRemote = true
        mockRepo.shouldFailLocal = true
        mockRepo.remoteError = APIError.statusCode(500)
        mockRepo.localError = SQLiteError.openDatabase(message: "DB error")
        let expectation = expectation(description: "Load fails")
        
        // When
        viewModel.load()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.error)
            XCTAssertTrue(self.viewModel.items.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadLocalitiesEmptyLocalShowsError() {
        // Given
        mockRepo.shouldFailRemote = true
        mockRepo.mockLocalities = []
        let expectation = expectation(description: "Load shows empty error")
        
        // When
        viewModel.load()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.error)
            XCTAssertTrue(self.viewModel.error?.contains("No hay localidades") ?? false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

