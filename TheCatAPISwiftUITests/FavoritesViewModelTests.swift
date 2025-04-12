//
//  FavoritesViewModelTests.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import XCTest
@testable import TheCatAPISwiftUI

class FavoritesViewModelTests: XCTestCase {
    
    func testFilteredFavoritesEmptySearch() async {
        let mockManager = await TestData.mockFavoritesManager()
        let viewModel = FavoritesViewModelMock(favoritesManager: mockManager)
        viewModel.searchText = ""
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 2)
        XCTAssertEqual(filteredBreeds[0].id, "beng")
        XCTAssertEqual(filteredBreeds[1].id, "abys")
    }
    
    func testFilteredFavoritesWithSearchByName() async {
        let mockManager = await TestData.mockFavoritesManager()
        let viewModel = FavoritesViewModelMock(favoritesManager: mockManager)
        viewModel.searchText = "aby"
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 1)
        XCTAssertEqual(filteredBreeds[0].id, "abys")
    }
    
    func testFilteredFavoritesWithSearchByOrigin() async {
        let mockManager = await TestData.mockFavoritesManager()
        let viewModel = FavoritesViewModelMock(favoritesManager: mockManager)
        viewModel.searchText = "egipto"
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 1)
        XCTAssertEqual(filteredBreeds[0].id, "abys")
    }
    
    func testFilteredFavoritesWithSearchByTemperament() async {
        let mockManager = await TestData.mockFavoritesManager()
        let viewModel = FavoritesViewModelMock(favoritesManager: mockManager)
        viewModel.searchText = "inteligente"
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 1)
        XCTAssertEqual(filteredBreeds[0].id, "abys")
    }
    
    func testFilteredFavoritesWithNoMatchingSearch() async {
        let mockManager = await TestData.mockFavoritesManager()
        let viewModel = FavoritesViewModelMock(favoritesManager: mockManager)
        viewModel.searchText = "noexiste"
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 0)
    }
    
    func testFilteredFavoritesWithNilManager() async {
        let viewModel = FavoritesViewModelMock(favoritesManager: nil)
        viewModel.searchText = ""
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 0)
    }
    
    func testFilteredFavoritesWithEmptyFavorites() async {
        let mockManager = await MockFavoritesManager()
        let viewModel = FavoritesViewModelMock(favoritesManager: mockManager)
        viewModel.searchText = ""
        
        let filteredBreeds = await viewModel.filteredFavorites
        
        XCTAssertEqual(filteredBreeds.count, 0)
    }
}
