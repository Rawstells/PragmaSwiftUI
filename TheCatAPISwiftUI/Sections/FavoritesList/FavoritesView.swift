//
//  FavoritesView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(FavoritesViewManager.self) private var favoritesManager: FavoritesViewManager
    @State private var viewModel: FavoritesViewModel
    @Environment(\.modelContext) private var modelContext
    @State var breeds: [BreedModel] = []

    init() {
        self._viewModel = State(
            wrappedValue: FavoritesViewModel(favoritesManager: nil)
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: .zero) {
                    SearchBar(
                        text: $viewModel.searchText,
                        placeholder: LocalizedStrings.searchPlaceholder,
                        suggestions: []
                    )
                    .padding(.horizontal,
                             Spacing.horizontal)
                    .padding(.bottom,
                             Spacing.vertical)
                    
                    ScrollView {
                        LazyVStack(spacing: Spacing.cardSpacing) {
                            if favoritesManager.favorites.isEmpty {
                                emptyFavoritesView
                            } else if viewModel.filteredFavorites.isEmpty && !viewModel.searchText.isEmpty {
                                noSearchResultsView
                            } else {
                                favoritesGridView
                            }
                        }
                        .padding(.vertical,
                                 Spacing.contentVertical)
                    }
                }
            }
            .navigationTitle(LocalizedStrings.title)
            .toolbar {
                if !favoritesManager.favorites.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(LocalizedStrings.sortByName) {
                                favoritesManager.loadFavorites(sortedBy: .name)
                            }
                            Button(LocalizedStrings.sortByDate) {
                                favoritesManager.loadFavorites(sortedBy: .dateAdded)
                            }
                        } label: {
                            Image(systemName: SystemImages.sort)
                        }
                    }
                }
            }
            .onAppear {
                viewModel = FavoritesViewModel(favoritesManager: favoritesManager)
                favoritesManager.loadFavorites()
                do {
                    breeds = try modelContext.fetch(FetchDescriptor<BreedModel>())
                } catch {
                    print("Error al cargar los datos: \(error)")
                }
            }
        }
    }
    
    private var emptyFavoritesView: some View {
        VStack(spacing: Spacing.emptyStateSpacing) {
            Image(systemName: SystemImages.heartSlash)
                .font(.system(size: Sizes.icon))
                .foregroundColor(.gray)
            
            Text(LocalizedStrings.emptyTitle)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(LocalizedStrings.emptySubtitle)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            NavigationLink(destination: BreedsListView()) {
                Text(LocalizedStrings.exploreButton)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(CornerRadius.button)
            }
        }
        .padding()
        .frame(maxWidth: .infinity,
               minHeight: Sizes.emptyMinHeight)
    }
    
    private var noSearchResultsView: some View {
        ContentUnavailableView(
            LocalizedStrings.noResultsTitle,
            systemImage: SystemImages.search,
            description: Text(LocalizedStrings.noResultsSubtitle)
        )
        .frame(maxWidth: .infinity,
               minHeight: Sizes.noResultsMinHeight)
    }
    
    private var favoritesGridView: some View {
        LazyVGrid(
            columns: [
                GridItem(.fixed(UIScreen.main.bounds.width / 2 - 24), spacing: 16),
                GridItem(.fixed(UIScreen.main.bounds.width / 2 - 24), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(viewModel.filteredFavorites) { breed in
                NavigationLink {
                    BreedDetailView(breed: breed)
                } label: {
                    if let imageUrl = breed.imageUrl {
                        FavoriteCardView(breed: breed, imageUrl: imageUrl)
                    } else {
                        FavoriteCardView(breed: breed, imageUrl: "")
                            .overlay(
                                Text(LocalizedStrings.noImage)
                                    .foregroundColor(.secondary)
                            )
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: UIScreen.main.bounds.width / 2 - 24, height: 250)
            }
        }
        .padding(.horizontal, 16)
    }
}

private extension FavoritesView {
    
    enum LocalizedStrings {
        static let title = "Mis Favoritos"
        static let searchPlaceholder = "Buscar en favoritos..."
        static let emptyTitle = "No tienes favoritos"
        static let emptySubtitle = "Explora las razas de gatos y añade tus favoritas"
        static let exploreButton = "Explorar razas"
        static let noResultsTitle = "No se encontraron resultados"
        static let noResultsSubtitle = "Prueba con otro término de búsqueda"
        static let sortByName = "Ordenar por nombre"
        static let sortByDate = "Ordenar por fecha"
        static let noImage = "Sin imagen"
    }
    
    enum SystemImages {
        static let heartSlash = "heart.slash"
        static let search = "magnifyingglass"
        static let sort = "arrow.up.arrow.down"
    }
    
    enum Sizes {
        static let icon: CGFloat = 70
        static let emptyMinHeight: CGFloat = 400
        static let noResultsMinHeight: CGFloat = 300
        static let gridMinWidth: CGFloat = 160
    }
    
    enum Spacing {
        static let horizontal: CGFloat = 8
        static let vertical: CGFloat = 8
        static let cardSpacing: CGFloat = 12
        static let contentVertical: CGFloat = 12
        static let emptyStateSpacing: CGFloat = 20
        static let gridSpacing: CGFloat = 16
    }
    
    enum CornerRadius {
        static let button: CGFloat = 10
    }
}



