//
//  ImageCacheTest.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import XCTest
@testable import TheCatAPISwiftUI

final class ImageCacheTests: XCTestCase {
    
    func test_cacheStoresAndRetrievesImage() {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/cat.jpg")!
        let image = UIImage(systemName: "pawprint")!
        
        cache.setImage(image, for: url)
        let retrieved = cache.getImage(for: url)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.pngData(), image.pngData())
    }
    
    func test_cacheReturnsNilForMissingURL() {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/unknown.jpg")!
        
        XCTAssertNil(cache.getImage(for: url))
    }
    
    func test_cacheOverwritesExistingImage() {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/cat.jpg")!
        let oldImage = UIImage(systemName: "pawprint")!
        let newImage = UIImage(systemName: "star.fill")!
        
        cache.setImage(oldImage, for: url)
        cache.setImage(newImage, for: url)
        
        let retrieved = cache.getImage(for: url)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.pngData(), newImage.pngData())
    }
}

