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
        let localNum = self.cleanedVersion().asVersionNumber
        let remoteNum = other.cleanedVersion().asVersionNumber
        
        if localNum < remoteNum { return .lower }
        if localNum > remoteNum { return .higher }
        return .equal
    }
    
    private var asVersionNumber: Int {
        return Int(self.replacingOccurrences(of: ".", with: "")) ?? 0
    }
    
    private func cleanedVersion() -> String {
        return self.filter { $0.isNumber || $0 == "." }
    }
}

enum VersionComparison {
    case lower
    case equal
    case higher
}
