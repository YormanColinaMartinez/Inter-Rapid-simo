//
//  UserRepository.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

protocol UserRepository {
    func save(user: User) async throws
    func getUser() async throws -> User?
    func deleteAll() async throws
}
