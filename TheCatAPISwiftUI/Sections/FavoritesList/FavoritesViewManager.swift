//
//  FavoritesManager.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import Foundation
import SwiftUI
import SwiftData
import Observation

@MainActor
@Observable
class FavoritesViewManager {
    var favorites: [BreedModel] = []
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContext = modelContainer.mainContext
        loadFavorites(sortedBy: .dateAdded)
    }
    
    enum SortOption {
        case name
        case dateAdded
    }
    
    func loadFavorites(sortedBy: SortOption) {
        let sortDescriptor: SortDescriptor<BreedModel>
        
        switch sortedBy {
        case .name:
            sortDescriptor = SortDescriptor(\.name)
        case .dateAdded:
            sortDescriptor = SortDescriptor(\.dateAdded, order: .reverse)
        }
        
        let descriptor = FetchDescriptor<BreedModel>(
            predicate: #Predicate { $0.dateAdded != nil },
            sortBy: [sortDescriptor]
        )
        
        do {
            favorites = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
        }
    }
    
    func loadFavorites() {        
        let descriptor = FetchDescriptor<BreedModel>(
            predicate: #Predicate { $0.dateAdded != nil },
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        
        do {
            let loadedFavorites = try modelContext.fetch(descriptor)
            print("Cargados \(loadedFavorites.count) favoritos")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.favorites = loadedFavorites
            }
        } catch {
            print("Failed to fetch favorites: \(error.localizedDescription)")
            favorites = []
        }
    }
    
    func toggleFavorite(breed: Breed) {
        let breedModel = breed.mapToModel()
        if isFavorite(breed) {
            removeFromFavorites(breed: breedModel)
        } else {
            if breedModel.imageUrl == nil && breed.imageUrl != nil {
                breedModel.imageUrl = breed.imageUrl
            }
            addToFavorites(breed: breedModel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.loadFavorites()
            }
        }
    }
    
    func isFavorite(_ breed: Breed) -> Bool {
        return favorites.contains { $0.id == breed.id }
    }
    
    private func addToFavorites(breed: BreedModel) {
        let descriptor = FetchDescriptor<BreedModel>(
            predicate: #Predicate { $0.id == breed.id }
        )
        
        do {
            let existingBreeds = try modelContext.fetch(descriptor)
            
            if let existingBreed = existingBreeds.first {
                existingBreed.dateAdded = Date()
                if existingBreed.imageUrl == nil && breed.imageUrl != nil {
                    existingBreed.imageUrl = breed.imageUrl
                }
            } else {
                let newBreed = breed
                newBreed.dateAdded = Date()
                modelContext.insert(newBreed)
            }
            
            try modelContext.save()
            loadFavorites()
        } catch {
            print("Failed to save favorite: \(error.localizedDescription)")
        }
    }
    
    private func removeFromFavorites(breed: BreedModel) {
        let descriptor = FetchDescriptor<BreedModel>(
            predicate: #Predicate { $0.id == breed.id }
        )
        
        do {
            let matches = try modelContext.fetch(descriptor)
            for match in matches {
                match.dateAdded = nil
            }
            try modelContext.save()
            loadFavorites()
        } catch {
            print("Failed to remove favorite: \(error.localizedDescription)")
        }
    }
}
