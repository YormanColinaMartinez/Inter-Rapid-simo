//
//  CameraPermissionManager.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import AVFoundation
import UIKit

enum CameraPermissionStatus {
    case authorized
    case denied
    case restricted
    case notDetermined
}

final class CameraPermissionManager {
    
    static func checkPermission() -> CameraPermissionStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
    
    static func requestPermission() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }
    
    static func isCameraAvailable() -> Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
}

