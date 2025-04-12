//
//  MockBreedsService.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import Foundation
@testable import TheCatAPISwiftUI

final class MockBreedsService: BreedsServiceProtocol {
    let success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func fetchBreeds() async throws -> [BreedModel] {
        if success {
            return [
                BreedModel(
                    id: "beng",
                    name: "Bengal",
                    temperament: "Activo, Curioso",
                    origin: "USA",
                    description: "Gato salvaje domesticado",
                    referenceImageId: "abc123",
                    wikipediaUrl: nil,
                    imageUrl: nil,
                    dateAdded: nil,
                    lifeSpan: "10 - 14",
                    adaptability: 4,
                    affectionLevel: 5,
                    childFriendly: 5,
                    dogFriendly: 4,
                    energyLevel: 5,
                    grooming: 2,
                    healthIssues: 1,
                    intelligence: 5,
                    sheddingLevel: 2,
                    socialNeeds: 4,
                    strangerFriendly: 4
                ),
                BreedModel(
                    id: "abys",
                    name: "Abyssinian",
                    temperament: "Curioso, Inteligente",
                    origin: "Egipto",
                    description: "Muy curioso y social",
                    referenceImageId: "xyz789",
                    wikipediaUrl: nil,
                    imageUrl: nil,
                    dateAdded: nil,
                    lifeSpan: "14 - 16",
                    adaptability: 4,
                    affectionLevel: 5,
                    childFriendly: 4,
                    dogFriendly: 4,
                    energyLevel: 5,
                    grooming: 2,
                    healthIssues: 1,
                    intelligence: 5,
                    sheddingLevel: 3,
                    socialNeeds: 4,
                    strangerFriendly: 3
                )
            ]
        } else {
            throw BreedsError.custom(message: "Error cargando razas")
        }
    }
    
    func fetchBreedImage(id: String) async throws -> String {
        return "https://cdn2.thecatapi.com/images/\(id).jpg"
    }
}
