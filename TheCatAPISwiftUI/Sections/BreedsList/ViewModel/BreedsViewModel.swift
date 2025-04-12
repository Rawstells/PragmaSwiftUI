//
//  BreedsViewModel.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class BreedsViewModel {
    private let service: BreedsServiceProtocol
    var breeds: [Breed] = []
    var isLoading = false
    var error: APIManager.APIError?
    var searchText = ""
    
    var filteredBreeds: [Breed] {
        if searchText.isEmpty {
            return breeds
        } else {
            return breeds.filter { breed in
                breed.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init(service: BreedsServiceProtocol = BreedsService()) {
        self.service = service
    }
    
    func fetchBreeds() async {
        isLoading = true
        error = nil
        
        do {
            let fetchedBreeds = try await service.fetchBreeds()
            breeds = fetchedBreeds.sorted { $0.name < $1.name }.map { $0.mapToBreed() }
        } catch {
            self.error = .custom(message: error.localizedDescription)
        }
        isLoading = false
    }
    
    func searchBreeds(matching query: String) -> [Breed] {
        if query.isEmpty {
            return breeds
        } else {
            return breeds.filter { breed in
                let name = breed.name.lowercased()
                let searchTerm = query.lowercased()
                
                return name.contains(searchTerm) ||
                breed.temperament.lowercased().contains(searchTerm) ||
                breed.origin.lowercased().contains(searchTerm)
            }
        }
    }
}

extension BreedsViewModel {
    var showEmptySearchResults: Bool {
        filteredBreeds.isEmpty && !searchText.isEmpty
    }

    var showEmptyBreedsView: Bool {
        breeds.isEmpty && error == nil && searchText.isEmpty
    }
}
