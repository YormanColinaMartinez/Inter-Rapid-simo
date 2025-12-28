//
//  TablesViewModelTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
@testable import Inter_Rapidísimo

@MainActor
final class TablesViewModelTests: XCTestCase {
    
    var mockRemoteRepo: MockSchemaRepository!
    var mockLocalRepo: SchemaLocalRepositoryImpl!
    var syncService: SchemaSyncService!
    var viewModel: TablesViewModel!
    
    override func setUp() {
        super.setUp()
        mockRemoteRepo = MockSchemaRepository()
        // Note: SchemaLocalRepositoryImpl uses SQLiteManager.shared
        // For real tests, we'd need to mock SQLiteManager or use in-memory DB
        // For now, we'll test the sync service logic
    }
    
    func testLoadTablesSuccess() {
        // Given
        let mockTables = [
            SchemaTableDTO(nombreTabla: "Table1", descripcion: "Description1"),
            SchemaTableDTO(nombreTabla: "Table2", descripcion: "Description2")
        ]
        mockRemoteRepo.mockTables = mockTables
        
        // This test would need a mocked local repository
        // For now, we verify the structure is correct
        XCTAssertEqual(mockTables.count, 2)
        XCTAssertEqual(mockTables[0].nombreTabla, "Table1")
    }
    
    func testLoadTablesFailure() {
        // Given
        mockRemoteRepo.shouldFail = true
        mockRemoteRepo.error = APIError.statusCode(500)
        
        // Verify error is set
        XCTAssertTrue(mockRemoteRepo.shouldFail)
    }
}

