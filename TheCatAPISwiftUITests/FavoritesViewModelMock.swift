//
//  FavoritesViewModelMock.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import Foundation
@testable import TheCatAPISwiftUI

@Observable
class FavoritesViewModelMock {
    var searchText = ""
    var favoritesManager: MockFavoritesManager?
    
    init(favoritesManager: MockFavoritesManager?) {
        self.favoritesManager = favoritesManager
    }
    
    @MainActor
    var filteredFavorites: [Breed] {
        guard let favoritesManager = favoritesManager, !favoritesManager.favorites.isEmpty else {
            return []
        }
        
        let mappedBreeds = favoritesManager.favorites.map { $0.mapToBreed() }
        
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
