//
//  FavoritesViewModel.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import Foundation
import Observation

@Observable
class FavoritesViewModel {
    var searchText = ""
    var favoritesManager: FavoritesViewManager?
    
    init(favoritesManager: FavoritesViewManager?) {
        self.favoritesManager = favoritesManager
    }
    
    @MainActor
    var filteredFavorites: [Breed] {
        guard let favoritesManager = favoritesManager, !favoritesManager.favorites.isEmpty else {
            print("Sin favoritos o manager nulo")
            return []
        }
        
        let mappedBreeds = favoritesManager.favorites.map { $0.mapToBreed() }
        print("Mapeados \(mappedBreeds.count) favoritos")
        
        if searchText.isEmpty {
            return mappedBreeds
        } else {
            return mappedBreeds.filter { breed in
                breed.name.lowercased().contains(searchText.lowercased()) ||
                breed.origin.lowercased().contains(searchText.lowercased()) ||
                breed.temperament.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
