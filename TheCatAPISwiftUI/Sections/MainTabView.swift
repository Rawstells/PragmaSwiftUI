//
//  MainTabView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 8/04/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            BreedsListView()
                .tabItem {
                    Label("Razas", systemImage: "pawprint")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "heart.fill")
                }
        }
    }
}
