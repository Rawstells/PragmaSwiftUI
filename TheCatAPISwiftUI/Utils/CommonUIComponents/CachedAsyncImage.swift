//
//  CachedAsyncImage.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 10/04/25.
//
import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let content: (AsyncImagePhase) -> Content
    
    init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
    }
    
    var body: some View {
        if let url = url, let cachedImage = ImageCache.shared.getImage(for: url) {
            content(.success(Image(uiImage: cachedImage)))
        } else {
            AsyncImage(url: url) { phase in
                content(phase)
                    .onAppear {
                        if case .success(let image) = phase, let url = url {
                            let renderer = ImageRenderer(content: image)
                            if let uiImage = renderer.uiImage {
                                ImageCache.shared.setImage(uiImage, for: url)
                            }
                        }
                    }
            }
        }
    }
}
