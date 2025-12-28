//
//  VersionViewModelTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

@MainActor
final class VersionViewModelTests: XCTestCase {
    
    var mockRepo: MockVersionRepository!
    var viewModel: VersionViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockVersionRepository(version: "1.0")
        viewModel = VersionViewModel(repo: mockRepo)
    }
    
    func testVersionCheckLower() {
        // Given
        mockRepo.version = "2.0"
        let expectation = expectation(description: "Version check completes")
        
        // When
        viewModel.check()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.isVersionValid)
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.errorMessage?.contains("nueva versión") ?? false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testVersionCheckHigher() {
        // Given
        mockRepo.version = "0.5"
        let expectation = expectation(description: "Version check completes")
        
        // When
        viewModel.check()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.isVersionValid)
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.errorMessage?.contains("superior") ?? false)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testVersionCheckEqual() {
        // Given
        mockRepo.version = "1.0"
        let expectation = expectation(description: "Version check completes")
        
        // When
        viewModel.check()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.isVersionValid)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testVersionCheckFailure() {
        // Given
        mockRepo.shouldFail = true
        let expectation = expectation(description: "Version check fails")
        
        // When
        viewModel.check()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.isVersionValid)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

