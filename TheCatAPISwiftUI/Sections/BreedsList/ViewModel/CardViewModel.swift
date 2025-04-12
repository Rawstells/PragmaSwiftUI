//
//  CardViewModel.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//

import Foundation
import SwiftUI


class CardViewModel: ObservableObject {
    let breed: Breed
    private let service: BreedsServiceProtocol

    @Published var imageState: ImageState = .loading
    
    enum ImageState: Equatable {
        case loading
        case success(Image)
        case failure
        
        static func == (lhs: ImageState, rhs: ImageState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading), (.failure, .failure):
                return true
            case (.success, .success):
                return true
            default:
                return false
            }
        }
    }
    
    init(breed: Breed, service: BreedsServiceProtocol = BreedsService()) {
        self.breed = breed
        self.service = service

        if let imageUrl = breed.imageUrl, let url = URL(string: imageUrl),
           let cachedImage = ImageCache.shared.getImage(for: url) {
            imageState = .success(Image(uiImage: cachedImage))
        }
    }
    
    @MainActor
    func getImage() async {
        guard let referenceImageId = breed.referenceImageId else { return }
        do {
            let imageUrl = try await service.fetchBreedImage(id: referenceImageId)
            breed.imageUrl = imageUrl
            await loadImage()
        } catch {
            
        }
    }
    
    @MainActor
    func loadImage() async {
        guard let imageUrl = breed.imageUrl, let url = URL(string: imageUrl) else {
            print("❌ URL inválida: \(breed.imageUrl ?? "nil")")
            imageState = .failure
            return
        }
        
        if let cachedImage = ImageCache.shared.getImage(for: url) {
            imageState = .success(Image(uiImage: cachedImage))
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setImage(uiImage, for: url)
                imageState = .success(Image(uiImage: uiImage))
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            print("❌ Error cargando imagen: \(error.localizedDescription)")
            imageState = .failure
        }
    }
}
