//
//  BreedModelMock.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import Foundation
@testable import TheCatAPISwiftUI

class BreedModelMock {
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
    var adaptability: Int
    var affectionLevel: Int
    var childFriendly: Int
    var dogFriendly: Int
    var energyLevel: Int
    var grooming: Int
    var healthIssues: Int
    var intelligence: Int
    var sheddingLevel: Int
    var socialNeeds: Int
    var strangerFriendly: Int
    
    init(id: String, name: String, temperament: String, origin: String, breedDescription: String, referenceImageId: String? = nil, wikipediaUrl: String?, imageUrl: String? = nil, dateAdded: Date? = nil, lifeSpan: String, adaptability: Int, affectionLevel: Int, childFriendly: Int, dogFriendly: Int, energyLevel: Int, grooming: Int, healthIssues: Int, intelligence: Int, sheddingLevel: Int, socialNeeds: Int, strangerFriendly: Int) {
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
    
    func mapToBreed() -> Breed {
        return Breed(
            id: id,
            name: name,
            temperament: temperament,
            origin: origin,
            breedDescription: breedDescription,
            referenceImageId: referenceImageId,
            wikipediaUrl: wikipediaUrl,
            imageUrl: imageUrl,
            dateAdded: dateAdded,
            lifeSpan: lifeSpan,
            adaptability: adaptability,
            affectionLevel: affectionLevel,
            childFriendly: childFriendly,
            dogFriendly: dogFriendly,
            energyLevel: energyLevel,
            grooming: grooming,
            healthIssues: healthIssues,
            intelligence: intelligence,
            sheddingLevel: sheddingLevel,
            socialNeeds: socialNeeds,
            strangerFriendly: strangerFriendly
        )
    }
}
