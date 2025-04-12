//
//  BreedService.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//

import Foundation

protocol BreedsServiceProtocol {
    func fetchBreeds() async throws -> [BreedModel]
    func fetchBreedImage(id: String) async throws -> String
}

final class BreedsService: BreedsServiceProtocol {
    private let apiManager: APIManagerProtocol
    private let baseURL = "https://api.thecatapi.com/v1"
    private let apiKey = "live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr"

    init(apiManager: APIManagerProtocol = APIManager()) {
        self.apiManager = apiManager
    }

    func fetchBreeds() async throws -> [BreedModel] {
        return try await apiManager.request(
            url: "\(baseURL)/breeds",
            httpMethod: "GET",
            headers: ["x-api-key": apiKey],
            requestBody: nil)
    }

    func fetchBreedImage(id: String) async throws -> String {
        let breed: BreedImage = try await apiManager.request(
            url: "\(baseURL)/images/\(id)",
            httpMethod: "GET",
            headers: ["x-api-key": apiKey],
            requestBody: nil)
        return breed.url
    }
}

