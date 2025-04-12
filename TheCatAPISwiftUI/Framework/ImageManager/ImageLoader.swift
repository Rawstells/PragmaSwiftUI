//
//  ImageLoader.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import Foundation

protocol ImageLoaderProtocol {
    func fetchBreedImages(breedId: String, limit: Int) async throws -> [BreedImage]
}

class ImageLoader: ImageLoaderProtocol {
    func fetchBreedImages(breedId: String, limit: Int) async throws -> [BreedImage] {
        let urlString = "https://api.thecatapi.com/v1/images/search?limit=\(limit)&breed_ids=\(breedId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([BreedImage].self, from: data)
    }
}
