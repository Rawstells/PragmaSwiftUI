//
//  ContentView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.

import SwiftUI

struct BreedsListView: View {
    @State private var viewModel = BreedsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                mainContentStack
            }
            .navigationTitle(LocalizedStrings.navigationTitle)
            .task(priority: .userInitiated) {
                await loadBreedsIfNeeded()
            }
            .refreshable {
                await refreshBreeds()
            }
            .alert(
                LocalizedStrings.errorTitle,
                isPresented: Binding(
                    get: { viewModel.error != nil },
                    set: { _ in viewModel.error = nil }
                ),
                presenting: viewModel.error
            ) { error in
                Button(LocalizedStrings.retryButton) {
                    Task { await viewModel.fetchBreeds() }
                }
            } message: { error in
                Text(error.localizedDescription)
            }
        }
    }
    
    private var mainContentStack: some View {
        VStack(spacing: 0) {
            searchBarView
            contentView
            Spacer()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.showEmptySearchResults {
            emptySearchResultsView
        } else if viewModel.showEmptyBreedsView {
            emptyBreedsView
        } else {
            breedsList
        }
    }
    
    private var searchBarView: some View {
        SearchBar(
            text: $viewModel.searchText,
            placeholder: LocalizedStrings.searchPlaceholder,
            suggestions: []
        )
        .padding(.horizontal, Spacing.small)
        .padding(.bottom, Spacing.small)
        .background(Color.white)
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, minHeight: Dimensions.minContentHeight)
            .accessibilityLabel(LocalizedStrings.loadingAccessibilityLabel)
    }
    
    private var emptySearchResultsView: some View {
        ContentUnavailableView(
            LocalizedStrings.emptySearchTitle,
            systemImage: SystemImages.search,
            description: Text(LocalizedStrings.emptySearchMessage)
        )
        .frame(maxWidth: .infinity, minHeight: Dimensions.minContentHeight)
    }
    
    private var emptyBreedsView: some View {
        ContentUnavailableView(
            LocalizedStrings.emptyBreedsTitle,
            systemImage: SystemImages.pawprint,
            description: Text(LocalizedStrings.emptyBreedsMessage)
        )
        .frame(maxWidth: .infinity, minHeight: Dimensions.minContentHeight)
    }
    
    private var breedsList: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.medium) {
                ForEach(viewModel.filteredBreeds) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)) {
                        BreedCardView(
                            breed: breed
                        )
                            .padding(.horizontal, Spacing.small)
                    }
                    .buttonStyle(.plain)
                    
                }
            }
            .padding(.vertical, Spacing.small)
        }
    }
    
    private func loadBreedsIfNeeded() async {
        guard viewModel.breeds.isEmpty else { return }
        await viewModel.fetchBreeds()
    }
    
    private func refreshBreeds() async {
        viewModel.searchText = ""
        await viewModel.fetchBreeds()
    }
}

// MARK: - Constants

private extension BreedsListView {
    enum Dimensions {
        static let minContentHeight: CGFloat = 200
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
    }
    
    enum SystemImages {
        static let search = "magnifyingglass"
        static let pawprint = "pawprint"
    }
    
    enum LocalizedStrings {
        static let navigationTitle = "Razas de Gatos"
        static let errorTitle = "Error"
        static let retryButton = "Reintentar"
        static let searchPlaceholder = "Buscar por nombre..."
        static let loadingAccessibilityLabel = "Cargando razas de gatos"
        static let emptySearchTitle = "No se encontraron resultados"
        static let emptySearchMessage = "Prueba con otro término de búsqueda"
        static let emptyBreedsTitle = "No hay razas disponibles"
        static let emptyBreedsMessage = "Intenta recargar la página"
    }
}

#Preview {
    BreedsListView()
}
