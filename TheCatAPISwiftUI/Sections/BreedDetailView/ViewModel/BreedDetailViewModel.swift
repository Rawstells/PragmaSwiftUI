//
//  BreedDetailViewModel.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI

@MainActor
final class BreedDetailViewModel: ObservableObject {
    // MARK: - Properties
    private let imageLoader: ImageLoaderProtocol
    
    // MARK: - Published
    @Published var additionalImages: [BreedImage] = []
    @Published var isWebViewLoaded = false
    @Published var isLoadingWebView = false
    @Published var pawLoadingOpacity: [Double] = [0.3, 0.3, 0.3]
    @Published var selectedImageIndex: Int = 0
    @Published var isLoading = false
    @Published var error: Error?
    
    // MARK: - Init
    init(imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.imageLoader = imageLoader
    }
    
    // MARK: - Public Methods
    
    func setupLoadingAnimation() {
        self.pawLoadingOpacity = [0.3, 0.3, 0.3]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.pawLoadingOpacity = [1.0, 0.5, 0.3] // 
            }
        }
    }
    
    func loadAdditionalImages(breedId: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            additionalImages = try await imageLoader.fetchBreedImages(breedId: breedId, limit: 10)
        } catch {
            self.error = error
            print("Error loading images: \(error.localizedDescription)")
        }
    }
    
    func selectImage(at index: Int) {
        selectedImageIndex = index
    }
}
