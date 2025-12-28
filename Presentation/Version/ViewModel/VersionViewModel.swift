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
                    // Aca se supone que no debe entrar a ningun lado pero quiero que en la prueba en todos los casos entre en el iniciar sesion
                    isVersionValid = true
                case .higher:
                    // Aca se supone que no debe entrar a ningun lado pero quiero que en la prueba en todos los casos entre en el iniciar sesion
                    errorMessage = "La versión instalada (\(localVersion)) es superior a la del servidor (\(remoteVersion)). Ambiente inconsistente."
                    isVersionValid = true
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
        let localParts = self.cleanedVersion().versionParts
        let remoteParts = other.cleanedVersion().versionParts
        
        let maxLength = max(localParts.count, remoteParts.count)
        
        for i in 0..<maxLength {
            let localPart = i < localParts.count ? localParts[i] : 0
            let remotePart = i < remoteParts.count ? remoteParts[i] : 0
            
            if localPart < remotePart {
                return .lower
            } else if localPart > remotePart {
                return .higher
            }
        }
        
        return .equal
    }
    
    private var versionParts: [Int] {
        return self.split(separator: ".").compactMap { Int($0) }
    }
    
    private func cleanedVersion() -> String {
        return self.filter { $0.isNumber || $0 == "." }
    }
}
