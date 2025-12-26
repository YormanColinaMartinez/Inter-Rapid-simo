//
//  PhotosRepository.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import Foundation

protocol PhotoRepository {
    func save(photo: Photo) async throws
    func fetchAll() async throws -> [Photo]
}
