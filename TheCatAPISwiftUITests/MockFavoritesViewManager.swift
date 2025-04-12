//
//  MockFavoritesViewManager.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import Foundation
@testable import TheCatAPISwiftUI

@MainActor
class MockFavoritesManager {
    var favorites: [BreedModelMock] = []
    
    func loadFavorites(sortedBy: FavoritesViewManager.SortOption = .dateAdded) {
    }
    
    func toggleFavorite(breed: Breed) {
    }
    
    func isFavorite(_ breed: Breed) -> Bool {
        return favorites.contains { $0.id == breed.id }
    }
}
