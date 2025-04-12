//
//  TheCatAPISwiftUIApp.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//

import SwiftUI
import SwiftData

@main
struct TheCatAPISwiftUIApp: App {
    private let modelContainer: ModelContainer
    @State private var favoritesManager: FavoritesViewManager

    init() {
        do {
            let schema = Schema([BreedModel.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.modelContainer = container
            let favManager = FavoritesViewManager(modelContainer: container)
            self._favoritesManager = State(wrappedValue: favManager)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(favoritesManager)
        }
    }
}
