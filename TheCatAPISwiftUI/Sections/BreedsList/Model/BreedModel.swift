//
//  BreedResultResponse.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.

import Foundation
import SwiftData

@Model
final class BreedModel: Identifiable, Sendable {
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
    
    init(id: String, name: String, temperament: String, origin: String, description: String, referenceImageId: String? = nil, wikipediaUrl: String?, imageUrl: String? = nil, dateAdded: Date? = nil, lifeSpan: String , adaptability: Int, affectionLevel: Int, childFriendly: Int, dogFriendly: Int, energyLevel: Int, grooming: Int, healthIssues: Int, intelligence: Int, sheddingLevel: Int, socialNeeds: Int, strangerFriendly: Int) {
        self.id = id
        self.name = name
        self.temperament = temperament
        self.origin = origin
        self.breedDescription = description
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
    
    enum CodingKeys: String, CodingKey {
        case id, name, temperament, origin, imageUrl, adaptability, grooming, intelligence
        case breedDescription = "description"
        case referenceImageId = "reference_image_id"
        case wikipediaUrl = "wikipedia_url"
        case lifeSpan = "life_span"
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case healthIssues = "health_issues"
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
    }
}

extension BreedModel: Codable {
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let temperament = try container.decode(String.self, forKey: .temperament)
        let origin = try container.decode(String.self, forKey: .origin)
        let description = try container.decode(String.self, forKey: .breedDescription)
        let referenceImageId = try container.decodeIfPresent(String.self, forKey: .referenceImageId)
        let wikipediaUrl = try container.decodeIfPresent(String.self, forKey: .wikipediaUrl)
        let imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        
        let lifeSpan = try container.decodeIfPresent(String.self, forKey: .lifeSpan)
        let adaptability = try container.decodeIfPresent(Int.self, forKey: .adaptability)
        let affectionLevel = try container.decodeIfPresent(Int.self, forKey: .affectionLevel)
        let childFriendly = try container.decodeIfPresent(Int.self, forKey: .childFriendly)
        let dogFriendly = try container.decodeIfPresent(Int.self, forKey: .dogFriendly)
        let energyLevel = try container.decodeIfPresent(Int.self, forKey: .energyLevel)
        let grooming = try container.decodeIfPresent(Int.self, forKey: .grooming)
        let healthIssues = try container.decodeIfPresent(Int.self, forKey: .healthIssues)
        let intelligence = try container.decodeIfPresent(Int.self, forKey: .intelligence)
        let sheddingLevel = try container.decodeIfPresent(Int.self, forKey: .sheddingLevel)
        let socialNeeds = try container.decodeIfPresent(Int.self, forKey: .socialNeeds)
        let strangerFriendly = try container.decodeIfPresent(Int.self, forKey: .strangerFriendly)
        
        
        self.init(id: id, name: name, temperament: temperament, origin: origin, description: description, referenceImageId: referenceImageId, wikipediaUrl: wikipediaUrl, imageUrl: imageUrl, dateAdded: nil, lifeSpan: lifeSpan ?? "", adaptability: adaptability ?? 0, affectionLevel: affectionLevel ?? 0, childFriendly: childFriendly ?? 0, dogFriendly: dogFriendly ?? 0, energyLevel: energyLevel ?? 0, grooming: grooming ?? 0, healthIssues: healthIssues ?? 0, intelligence: intelligence ?? 0, sheddingLevel: sheddingLevel ?? 0, socialNeeds: socialNeeds ?? 0, strangerFriendly: strangerFriendly ?? 0)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(temperament, forKey: .temperament)
        try container.encode(origin, forKey: .origin)
        try container.encode(breedDescription, forKey: .breedDescription)
        try container.encodeIfPresent(referenceImageId, forKey: .referenceImageId)
        try container.encodeIfPresent(wikipediaUrl, forKey: .wikipediaUrl)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(lifeSpan, forKey: .lifeSpan)
        try container.encodeIfPresent(adaptability, forKey: .adaptability)
        try container.encodeIfPresent(affectionLevel, forKey: .affectionLevel)
        try container.encodeIfPresent(childFriendly, forKey: .childFriendly)
        try container.encodeIfPresent(dogFriendly, forKey: .dogFriendly)
        try container.encodeIfPresent(energyLevel, forKey: .energyLevel)
        try container.encodeIfPresent(grooming, forKey: .grooming)
        try container.encodeIfPresent(healthIssues, forKey: .healthIssues)
        try container.encodeIfPresent(intelligence, forKey: .intelligence)
        try container.encodeIfPresent(sheddingLevel, forKey: .sheddingLevel)
        try container.encodeIfPresent(socialNeeds, forKey: .socialNeeds)
        try container.encodeIfPresent(strangerFriendly, forKey: .strangerFriendly)
    }
}

extension BreedModel {
    func mapToBreed() -> Breed {
        return Breed(id: id, name: name, temperament: temperament, origin: origin, breedDescription: breedDescription, referenceImageId: referenceImageId, wikipediaUrl: wikipediaUrl, imageUrl: imageUrl, dateAdded: dateAdded, lifeSpan: lifeSpan, adaptability: adaptability ?? 0, affectionLevel: affectionLevel ?? 0, childFriendly: childFriendly ?? 0, dogFriendly: dogFriendly ?? 0, energyLevel: energyLevel ?? 0, grooming: grooming ?? 0, healthIssues: healthIssues ?? 0, intelligence: intelligence ?? 0, sheddingLevel: sheddingLevel ?? 0, socialNeeds: socialNeeds ?? 0, strangerFriendly: strangerFriendly ?? 0)
    }
}
