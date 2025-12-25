//
//  VersionViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 24/12/25.
//

import Foundation

@MainActor
final class VersionViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var isVersionValid = false
    
    private let repo: VersionRepository
    
    init(repo: VersionRepository) {
        self.repo = repo
    }
    
    func check() {
        Task {
            do {
                let dto = try await repo.validateVersion()
                
                let remoteVersion = dto.version
                let localVersion = Bundle.main
                    .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
                
                switch localVersion.compareVersion(to: remoteVersion) {
                case .lower:
                    errorMessage = "Hay una nueva versión disponible (\(remoteVersion)). Por favor actualiza la app."
                    
                case .higher:
                    errorMessage = "La versión instalada (\(localVersion)) es superior a la del servidor (\(remoteVersion)). Ambiente inconsistente."
                    
                case .equal:
                    isVersionValid = true
                }
                
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}


extension String {
    func compareVersion(to other: String) -> VersionComparison {
        let localNumber = Int(self.replacingOccurrences(of: ".", with: "")) ?? 0
        let remoteNumber = Int(other.replacingOccurrences(of: ".", with: "")) ?? 0
        
        if localNumber < remoteNumber {
            return .lower
        } else if localNumber > remoteNumber {
            return .higher
        } else {
            return .equal
        }
    }
}


enum VersionComparison {
    case lower
    case equal
    case higher
}
