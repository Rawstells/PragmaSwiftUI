//
//  BreedsViewModelTests.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import XCTest
@testable import TheCatAPISwiftUI

@MainActor
final class BreedsViewModelTests: XCTestCase {
    
    func test_fetchBreeds_success() async {
        let service = MockBreedsService(success: true)
        let viewModel = BreedsViewModel(service: service)
        
        await viewModel.fetchBreeds()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.breeds.count, 2)
        XCTAssertEqual(viewModel.breeds.first?.name, "Abyssinian")
    }
    
    func test_fetchBreeds_failure() async {
        let service = MockBreedsService(success: false)
        let viewModel = BreedsViewModel(service: service)
        
        await viewModel.fetchBreeds()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.breeds.isEmpty)
    }
    
    func test_filteredBreeds_whenSearchTextEmpty_returnsAll() async {
        let service = MockBreedsService(success: true)
        let viewModel = BreedsViewModel(service: service)
        await viewModel.fetchBreeds()
        
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredBreeds.count, 2)
    }
    
    func test_filteredBreeds_whenSearchText_matchesByName() async {
        let service = MockBreedsService(success: true)
        let viewModel = BreedsViewModel(service: service)
        await viewModel.fetchBreeds()
        
        viewModel.searchText = "beng"
        XCTAssertEqual(viewModel.filteredBreeds.count, 1)
        XCTAssertEqual(viewModel.filteredBreeds.first?.name, "Bengal")
    }
    
    func test_searchBreeds_matchingByTemperamentAndOrigin() async {
        let service = MockBreedsService(success: true)
        let viewModel = BreedsViewModel(service: service)
        await viewModel.fetchBreeds()
        
        let result = viewModel.searchBreeds(matching: "Egipto")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.origin, "Egipto")
    }
}
