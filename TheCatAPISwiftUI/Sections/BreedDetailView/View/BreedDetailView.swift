//
//  BreedDetailView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI

struct BreedDetailView: View {
    let breed: Breed
    @StateObject private var viewModel: BreedDetailViewModel
    @Environment(FavoritesViewManager.self) private var favoritesManager: FavoritesViewManager
    @State private var isPresentWebView = false
    @State private var selectedImageURL: String? = nil
    @State private var isShowingFullscreenImage = false
    
    private let imageCache = ImageCache.shared
    
    init(breed: Breed) {
        self.breed = breed
        self._viewModel = StateObject(wrappedValue: BreedDetailViewModel())
    }
    
    var body: some View {
        VStack(spacing: Spacing.zero) {
            ZStack {
                CachedAsyncImage(url: URL(string: breed.imageUrl ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: Dimensions.imageHeight)
                            .background(Color(.systemGray5))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .background(Color.black.opacity(Dimensions.imageBackgroundOpacity))
                            .frame(maxWidth: .infinity)
                            .frame(height: Dimensions.imageHeight)
                    case .failure:
                        errorImageView
                    @unknown default:
                        EmptyView()
                    }
                }
                favoriteButton
            }
            .background(Color(.systemGray6))
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: Spacing.medium) {
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text(breed.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("\(LocalizedStrings.originTitle): \(breed.origin)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, Spacing.large)
                    .padding(.top, Spacing.large)
                    
                    Divider()
                        .padding(.horizontal, Spacing.large)
                    
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text(LocalizedStrings.temperamentTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        FlowLayout(spacing: Spacing.small) {
                            ForEach(breed.temperament.components(separatedBy: ", "), id: \.self) { trait in
                                Text(trait)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, Spacing.temperamentHorizontal)
                                    .padding(.vertical, Spacing.temperamentVertical)
                                    .background(Color.accentColor.opacity(Opacity.temperamentBackground))
                                    .cornerRadius(CornerRadius.temperament)
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.large)
                    
                    Divider()
                        .padding(.horizontal, Spacing.large)
                    
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text(LocalizedStrings.descriptionTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text(breed.breedDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(Spacing.textLine)
                        moreInfoButton
                            .padding(.top, Spacing.medium)
                            .padding(.bottom, Spacing.large)
                    }
                    .padding(.horizontal, Spacing.large)
                    .padding(.bottom, Spacing.large)
                    
                    Divider()
                        .padding(.horizontal, Spacing.large)
                    
                    VStack(alignment: .leading) {
                        BreedCharacteristicsView(breed: breed)
                    }
                    .padding(.horizontal, Spacing.large)
                    .padding(.vertical, Spacing.large)
                    
                    Divider()
                        .padding(.horizontal, Spacing.large)
                    
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        Text(LocalizedStrings.additionalImagesTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.horizontal, Spacing.large)
                        
                        if !viewModel.additionalImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Spacing.medium) {
                                    ForEach(viewModel.additionalImages, id: \.id) { breedImage in
                                        carouselImage(for: breedImage)
                                            .onTapGesture {
                                                selectedImageURL = breedImage.url
                                                isShowingFullscreenImage = true
                                            }
                                            .onAppear {
                                                Task {
                                                    await preloadImage(urlString: breedImage.url)
                                                }
                                            }
                                    }
                                }
                                .padding(.horizontal, Spacing.large)
                                .padding(.vertical, Spacing.small)
                            }
                        } else {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .padding(.bottom, Spacing.large)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .task {
            await viewModel.loadAdditionalImages(breedId: breed.id)
            if !viewModel.additionalImages.isEmpty {
                for image in viewModel.additionalImages {
                    await preloadImage(urlString: image.url)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingFullscreenImage) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if let imageURL = selectedImageURL, let url = URL(string: imageURL) {
                    CachedAsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.white)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .transition(.opacity)
                        case .failure:
                            Image(systemName: SystemImages.photoOnRectangle)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .transition(.opacity)
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingFullscreenImage = false
                        }) {
                            Image(systemName: SystemImages.xmark)
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func preloadImage(urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        if imageCache.getImage(for: url) != nil {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                imageCache.setImage(image, for: url)
            }
        } catch {
            print("\(LocalizedStrings.preloadError) \(error.localizedDescription)")
        }
    }
    
    private var favoriteButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: Animation.durationFast, dampingFraction: Animation.dampingFraction)) {
                        favoritesManager.toggleFavorite(breed: breed)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                } label: {
                    Image(systemName: favoritesManager.isFavorite(breed) ? SystemImages.heartFill : SystemImages.heart)
                        .foregroundColor(favoritesManager.isFavorite(breed) ? .red : .white)
                        .font(.system(size: Dimensions.iconSize))
                        .padding(Dimensions.iconPadding)
                        .background(Color.black.opacity(Opacity.buttonBackground))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(Opacity.shadow), radius: Dimensions.shadowRadius, x: 0, y: 1)
                }
                .padding(Dimensions.buttonPadding)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var moreInfoButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPresentWebView = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                viewModel.isWebViewLoaded = false
            }
        }) {
            HStack {
                Text(LocalizedStrings.moreInfo)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.trailing, 4)
                
                Image(systemName: SystemImages.pawprint)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                    .symbolEffect(.bounce, options: .speed(2), value: viewModel.isLoadingWebView)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.accentColor)
                    
                    if viewModel.isLoadingWebView {
                        ForEach(0..<5) { index in
                            Image(systemName: SystemImages.pawprint)
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.1))
                                .offset(x: CGFloat(index * 30 - 60), y: 0)
                                .opacity(viewModel.isLoadingWebView ? 1 : 0)
                                .animation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: viewModel.isLoadingWebView
                                )
                        }
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, 4)
        .sheet(isPresented: $isPresentWebView) {
            NavigationStack {
                ZStack {
                    Color(.systemBackground).edgesIgnoringSafeArea(.all)
                    
                    WebView(urlString: breed.wikipediaUrl)
                        .opacity(viewModel.isWebViewLoaded ? 1 : 0)
                        .ignoresSafeArea()
                        .onAppear {
                            viewModel.isLoadingWebView = true
                        }
                    
                    if !viewModel.isWebViewLoaded {
                        VStack(spacing: 20) {
                            HStack(spacing: 10) {
                                ForEach(0..<3, id: \.self) { index in
                                    Image(systemName: SystemImages.pawprint)
                                        .foregroundColor(.accentColor)
                                        .scaleEffect(1.5)
                                        .opacity(viewModel.pawLoadingOpacity[index])
                                        .animation(
                                            .easeInOut(duration: 0.6)
                                            .repeatForever()
                                            .delay(Double(index) * 0.2),
                                            value: viewModel.pawLoadingOpacity
                                        )
                                }
                            }
                            
                            Text(LocalizedStrings.loadingInfo)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .onAppear {
                            viewModel.setupLoadingAnimation()
                        }
                    }
                }
                .navigationTitle(LocalizedStrings.moreInfo)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeIn(duration: 0.4)) {
                            viewModel.isWebViewLoaded = true
                            viewModel.isLoadingWebView = false
                        }
                    }
                }
            }
        }
    }
    
    private func carouselImage(for breedImage: BreedImage) -> some View {
        CachedAsyncImage(url: URL(string: breedImage.url)) { phase in
            Group {
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                case .failure:
                    errorThumbnailView
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: Dimensions.carouselImageSize, height: Dimensions.carouselImageSize)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(Color.white.opacity(Opacity.thumbnailBorder), lineWidth: Dimensions.defaultBorderWidth)
            )
            .shadow(color: Color.black.opacity(Opacity.shadow), radius: Dimensions.shadowRadius, x: 0, y: 1)
            .onAppear {
                if let url = URL(string: breedImage.url) {
                    let _ = URLSession.shared.dataTask(with: url).resume()
                }
            }
        }
        .contentShape(Rectangle())
    }
    
    func fullScreenImage(for breedImage: BreedImage, isPresented: Binding<Bool>) -> some View {
        CachedAsyncImage(url: URL(string: breedImage.url)) { phase in
            Group {
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.8))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.8))
                        .onTapGesture {
                            isPresented.wrappedValue = false
                        }
                case .failure:
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                        Text("No se pudo cargar la imagen")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.8))
                @unknown default:
                    EmptyView()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var errorImageView: some View {
        VStack {
            Image(systemName: SystemImages.photoOnRectangle)
                .font(.system(size: Dimensions.errorIconSize))
                .foregroundColor(.gray)
            Text(LocalizedStrings.errorLoadImage)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
    
    private var errorThumbnailView: some View {
        Image(systemName: SystemImages.photoOnRectangle)
            .frame(width: Dimensions.thumbnailSize, height: Dimensions.thumbnailSize)
            .background(Color(.systemGray5))
            .foregroundColor(.white)
    }
    
    struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
        }
    }
}


// MARK: - Constants
private extension BreedDetailView {
    private enum Dimensions {
        static let imageHeight: CGFloat = 250
        static let galleryHeight: CGFloat = 80
        static let thumbnailSize: CGFloat = 60
        static let carouselImageSize: CGFloat = 120
        static let iconSize: CGFloat = 22
        static let errorIconSize: CGFloat = 50
        static let iconPadding: CGFloat = 10
        static let buttonPadding: CGFloat = 16
        static let shadowRadius: CGFloat = 2
        static let selectedBorderWidth: CGFloat = 3
        static let defaultBorderWidth: CGFloat = 1
        static let imageBackgroundOpacity: Double = 0.05
    }
    
    private enum Spacing {
        static let zero: CGFloat = 0
        static let small: CGFloat = 8
        static let medium: CGFloat = 10
        static let large: CGFloat = 16
        static let textLine: CGFloat = 6
        static let temperamentHorizontal: CGFloat = 10
        static let temperamentVertical: CGFloat = 5
    }
    
    private enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 8
        static let temperament: CGFloat = 20
    }
    
    private enum Opacity {
        static let shadow: Double = 0.3
        static let buttonBackground: Double = 0.3
        static let thumbnailBorder: Double = 0.7
        static let imageBackground: Double = 0.05
        static let temperamentBackground: Double = 0.1
    }
    
    private enum Animation {
        static let durationFast: Double = 0.3
        static let dampingFraction: Double = 0.6
    }
    
    enum SystemImages {
        static let photoOnRectangle = "photo.on.rectangle.angled"
        static let heartFill = "heart.fill"
        static let heart = "heart"
        static let xmark = "xmark"
        static let pawprint = "pawprint.fill"
    }
    
    enum LocalizedStrings {
        static let originTitle = "Origen"
        static let temperamentTitle = "Temperamento"
        static let descriptionTitle = "Descripción"
        static let errorLoadImage = "Error al cargar la imagen"
        static let preloadError = "Error preloading image:"
        static let moreInfo = "Más información"
        static let additionalImagesTitle = "Más fotos de esta raza"
        static let loadingInfo = "Cargando información..."
    }
}


