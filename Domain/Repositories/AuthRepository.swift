//
//  AuthRepository.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

protocol AuthRepository {
    func login() async throws -> User
}
