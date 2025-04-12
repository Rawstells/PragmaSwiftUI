//
//  MockImageLoader.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import Foundation
@testable import TheCatAPISwiftUI

final class MockImageLoader: ImageLoaderProtocol {
    private let success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func fetchBreedImages(breedId: String, limit: Int) async throws -> [BreedImage] {
        if success {
            return [
                BreedImage(id: "1", url: "https://cdn2.thecatapi.com/images/1.jpg", width: 640, height: 480),
                BreedImage(id: "2", url: "https://cdn2.thecatapi.com/images/2.jpg", width: 640, height: 480),
                BreedImage(id: "3", url: "https://cdn2.thecatapi.com/images/3.jpg", width: 640, height: 480)
            ]
        } else {
            throw NSError(domain: "ImageLoading", code: 500, userInfo: nil)
        }
    }
}
