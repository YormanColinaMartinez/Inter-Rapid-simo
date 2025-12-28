//
//  HomeViewModelTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    var mockUserRepo: MockUserRepository!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        // Note: HomeViewModel uses UserRepositoryImpl directly
        // We'd need to refactor to inject dependency or use a different approach
        // For now, we test the structure
    }
    
    func testLoadUserSuccess() async {
        // This test would require dependency injection in HomeViewModel
        // For now, we verify the structure exists
        let viewModel = HomeViewModel()
        await viewModel.loadUser()
        // Verify user is loaded (would need mock)
    }
}

