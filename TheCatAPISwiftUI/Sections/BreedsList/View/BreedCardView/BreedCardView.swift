//
//  BreedCardView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//
import SwiftUI

struct BreedCardView: View {
    private let breed: Breed
    @StateObject private var viewModel: CardViewModel
    
    init(breed: Breed) {
        self.breed = breed
        self._viewModel = StateObject(wrappedValue: CardViewModel(breed: breed))
    }
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            breedImageView
            breedInformationView
            Spacer()
        }
        .padding(Constants.padding)
        .background(Color(.systemBackground))
        .task(priority: .userInitiated) {
            await viewModel.getImage()
        }
    }
        
    private var breedImageView: some View {
        ZStack {
            switch viewModel.imageState {
            case .loading:
                ProgressView()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                
            case .failure:
                placeholderImageView
            }
        }
    }
    
    private var placeholderImageView: some View {
        Image(systemName: SystemImages.photoOnRectangle)
            .font(.system(size: Constants.placeholderIconSize))
            .foregroundColor(.gray)
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    private var breedInformationView: some View {
        VStack(alignment: .leading, spacing: Constants.textSpacing) {
            Text(breed.name)
                .font(.title)
                .foregroundStyle(Color.darkGray)
            
            Text(breed.origin)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(breed.temperament)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.gray)
        }
    }
}

private extension BreedCardView {
    enum Constants {
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 8
        static let imageSize: CGFloat = 100
        static let cornerRadius: CGFloat = 12
        static let textSpacing: CGFloat = 4
        static let placeholderIconSize: CGFloat = 40
    }
    
    enum SystemImages {
        static let photoOnRectangle = "photo.on.rectangle.angled"
    }
}

#Preview {
    BreedCardView(breed: Breed(
        id: "beng",
        name: "Bengal",
        temperament: "Curioso, energético, amigable",
        origin: "Estados Unidos",
        breedDescription: "Raza conocida por su pelaje similar al de un leopardo.",
        referenceImageId: "0XYvRd7oD",
        wikipediaUrl: "https://en.wikipedia.org/wiki/Bengal_cat",
        imageUrl: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg",
        lifeSpan: "5 - 6",
        adaptability: 5,
        affectionLevel: 5,
        childFriendly: 5,
        dogFriendly: 5,
        energyLevel: 5,
        grooming: 5,
        healthIssues: 5,
        intelligence: 5,
        sheddingLevel: 5,
        socialNeeds: 5,
        strangerFriendly: 5
    ))
    .padding()
}
