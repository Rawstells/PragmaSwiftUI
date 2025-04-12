//
//  FavoriteCardView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI
import SwiftData

struct FavoriteCardView: View {
    let breed: Breed
    let imageUrl: String
    @Environment(FavoritesViewManager.self) private var favoritesManager
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(height: 160)
                
                CachedAsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: SystemImages.photo)
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    default:
                        ProgressView()
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2 - 24, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.image))
            }
            .frame(height: 160)
            
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(breed.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(breed.origin)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Spacer(minLength: 4)
                
                favoriteButton
            }
            .padding(Spacing.medium)
            .frame(height: 90)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(CornerRadius.card)
        .modifier(CardShadowEffect(isPressed: isPressed))
        .scaleEffect(isPressed ? Dimensions.pressedScale : 1.0)
        .animation(.spring(response: Animation.tapResponse, dampingFraction: Animation.damping), value: isPressed)
        .overlay(cardBorder)
        .frame(width: UIScreen.main.bounds.width / 2 - 24, height: 250)
    }
    
    // MARK: - Subviews
    
    private var breedImageView: some View {
        CachedAsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: SystemImages.photo)
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            default:
                ProgressView()
            }
        }
        .frame(height: Dimensions.imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.image))
    }
    
    private var breedInfoView: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(breed.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(breed.origin)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            favoriteButton
        }
        .padding(Spacing.medium)
    }
    
    private var favoriteButton: some View {
        Button(action: handleFavoriteToggle) {
            Image(systemName: SystemImages.heartFill)
                .foregroundColor(.red)
                .padding(Spacing.small)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, Spacing.extraSmall)
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: CornerRadius.card)
            .stroke(Color.secondary.opacity(Opacity.border), lineWidth: Dimensions.borderWidth)
    }
    
    // MARK: - Private Methods
    
    private func handleFavoriteToggle() {
        withAnimation {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            favoritesManager.toggleFavorite(breed: breed)
        }
    }
}

// MARK: - View Modifiers

struct CardShadowEffect: ViewModifier {
    let isPressed: Bool
    
    func body(content: Content) -> some View {
        content.shadow(
            color: Color.black.opacity(isPressed ? FavoriteCardView.Opacity.pressedShadow : FavoriteCardView.Opacity.defaultShadow),
            radius: isPressed ? FavoriteCardView.Dimensions.pressedShadowRadius : FavoriteCardView.Dimensions.defaultShadowRadius,
            x: 0,
            y: isPressed ? FavoriteCardView.Dimensions.pressedShadowY : FavoriteCardView.Dimensions.defaultShadowY
        )
    }
}

// MARK: - Constants

private extension FavoriteCardView {
    enum Dimensions {
        static let imageHeight: CGFloat = 120
        static let borderWidth: CGFloat = 1
        static let pressedScale: CGFloat = 0.98
        static let pressedShadowRadius: CGFloat = 2
        static let defaultShadowRadius: CGFloat = 4
        static let pressedShadowY: CGFloat = 1
        static let defaultShadowY: CGFloat = 2
    }
    
    enum Spacing {
        static let extraSmall: CGFloat = 4
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
    }
    
    enum CornerRadius {
        static let card: CGFloat = 16
        static let image: CGFloat = 12
    }
    
    enum Opacity {
        static let border: Double = 0.2
        static let pressedShadow: Double = 0.05
        static let defaultShadow: Double = 0.1
    }
    
    enum Animation {
        static let tapResponse: Double = 0.3
        static let damping: Double = 0.6
        static let tapDuration: Double = 0.1
    }
    
    enum SystemImages {
        static let photo = "photo"
        static let heartFill = "heart.fill"
    }
}
