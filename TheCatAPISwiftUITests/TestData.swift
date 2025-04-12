//
//  TestData.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import Foundation
@testable import TheCatAPISwiftUI

enum TestData {
    
    static let sampleBreed = Breed(
        id: "abys",
        name: "Abyssinian",
        temperament: "Curioso, Energético",
        origin: "Egipto",
        breedDescription: "Muy curioso y social.",
        referenceImageId: "ab123",
        wikipediaUrl: "https://en.wikipedia.org/wiki/Abyssinian_cat",
        imageUrl: "https://cdn2.thecatapi.com/images/abys.jpg",
        dateAdded: Date(),
        lifeSpan: "12 - 15",
        adaptability: 5,
        affectionLevel: 4,
        childFriendly: 5,
        dogFriendly: 4,
        energyLevel: 5,
        grooming: 3,
        healthIssues: 2,
        intelligence: 5,
        sheddingLevel: 3,
        socialNeeds: 4,
        strangerFriendly: 4
    )
    
    @MainActor
    static func mockFavoritesManager() -> MockFavoritesManager {
        let manager = MockFavoritesManager()
        manager.favorites = [
            mockBreedModel(id: "beng", name: "Bengal", origin: "USA", temperament: "Activo, Juguetón"),
            mockBreedModel(id: "abys", name: "Abyssinian", origin: "Egipto", temperament: "Curioso, Inteligente")
        ]
        return manager
    }
    
    static func mockBreedModel(
        id: String = "beng",
        name: String = "Bengal",
        origin: String = "USA",
        temperament: String = "Activo, Juguetón"
    ) -> BreedModelMock {
        return BreedModelMock(
            id: id,
            name: name,
            temperament: temperament,
            origin: origin,
            breedDescription: "Una raza de gato muy activa.",
            referenceImageId: "ref123",
            wikipediaUrl: "https://en.wikipedia.org/wiki/Bengal_cat",
            imageUrl: "https://cdn2.thecatapi.com/images/\(id).jpg",
            dateAdded: Date(),
            lifeSpan: "12 - 16",
            adaptability: 4,
            affectionLevel: 5,
            childFriendly: 4,
            dogFriendly: 4,
            energyLevel: 5,
            grooming: 2,
            healthIssues: 1,
            intelligence: 5,
            sheddingLevel: 3,
            socialNeeds: 5,
            strangerFriendly: 4
        )
    }
}
