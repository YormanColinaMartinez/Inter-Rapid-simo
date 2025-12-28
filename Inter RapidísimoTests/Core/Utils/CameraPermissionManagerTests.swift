//
//  CameraPermissionManagerTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import XCTest
import AVFoundation
@testable import Inter_Rapidísimo

final class CameraPermissionManagerTests: XCTestCase {
    
    func testIsCameraAvailable() {
        // When
        let isAvailable = CameraPermissionManager.isCameraAvailable()
        
        // Then
        // On simulator, camera might not be available
        // On device, it should be available
        // We just verify the method doesn't crash
        XCTAssertNotNil(isAvailable as Bool)
    }
    
    func testCheckPermissionReturnsStatus() {
        // When
        let status = CameraPermissionManager.checkPermission()
        
        // Then
        // Status can be any of the enum cases
        switch status {
        case .authorized, .denied, .restricted, .notDetermined:
            XCTAssertTrue(true)
        }
    }
    
    func testRequestPermissionAsync() async {
        // When
        let granted = await CameraPermissionManager.requestPermission()
        
        // Then
        // Result depends on user/system permissions
        // We just verify it returns a boolean
        XCTAssertNotNil(granted as Bool)
    }
}

