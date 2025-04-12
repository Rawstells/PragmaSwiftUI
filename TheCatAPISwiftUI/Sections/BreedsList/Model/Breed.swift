//
//  Breed.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 11/04/25.
//

import Foundation

final class Breed: Identifiable {
    var id: String
    var name: String
    var temperament: String
    var origin: String
    var breedDescription: String
    var referenceImageId: String?
    var wikipediaUrl: String?
    var imageUrl: String?
    var dateAdded: Date?

    var lifeSpan: String
    var adaptability: Int?
    var affectionLevel: Int?
    var childFriendly: Int?
    var dogFriendly: Int?
    var energyLevel: Int?
    var grooming: Int?
    var healthIssues: Int?
    var intelligence: Int?
    var sheddingLevel: Int?
    var socialNeeds: Int?
    var strangerFriendly: Int?

    internal init(id: String, name: String, temperament: String, origin: String, breedDescription: String, referenceImageId: String? = nil, wikipediaUrl: String?,imageUrl: String? = nil, dateAdded: Date? = nil, lifeSpan: String, adaptability: Int, affectionLevel: Int, childFriendly: Int, dogFriendly: Int, energyLevel: Int, grooming: Int, healthIssues: Int, intelligence: Int, sheddingLevel: Int, socialNeeds: Int, strangerFriendly: Int) {
        self.id = id
        self.name = name
        self.temperament = temperament
        self.origin = origin
        self.breedDescription = breedDescription
        self.referenceImageId = referenceImageId
        self.wikipediaUrl = wikipediaUrl
        self.imageUrl = imageUrl
        self.dateAdded = dateAdded
        self.lifeSpan = lifeSpan
        self.adaptability = adaptability
        self.affectionLevel = affectionLevel
        self.childFriendly = childFriendly
        self.dogFriendly = dogFriendly
        self.energyLevel = energyLevel
        self.grooming = grooming
        self.healthIssues = healthIssues
        self.intelligence = intelligence
        self.sheddingLevel = sheddingLevel
        self.socialNeeds = socialNeeds
        self.strangerFriendly = strangerFriendly
    }
}

extension Breed {
    func mapToModel() -> BreedModel {
        return BreedModel(id: id, name: name, temperament: temperament, origin: origin, description: breedDescription, referenceImageId: referenceImageId, wikipediaUrl: wikipediaUrl, imageUrl: imageUrl, dateAdded: dateAdded, lifeSpan: lifeSpan, adaptability: adaptability ?? 0, affectionLevel: affectionLevel ?? 0, childFriendly: childFriendly ?? 0, dogFriendly: dogFriendly ?? 0, energyLevel: energyLevel ?? 0, grooming: grooming ?? 0, healthIssues: healthIssues ?? 0, intelligence: intelligence ?? 0, sheddingLevel: sheddingLevel ?? 0, socialNeeds: socialNeeds ?? 0, strangerFriendly: strangerFriendly ?? 0)
    }
}
