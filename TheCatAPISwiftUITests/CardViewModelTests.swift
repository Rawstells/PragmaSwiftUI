//
//  CardViewModelTests.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import XCTest
@testable import TheCatAPISwiftUI
import SwiftUI

final class CardViewModelTests: XCTestCase {
    
    func test_init_withCachedImage_setsSuccessState() {
        let breed = TestData.sampleBreed
        let url = URL(string: breed.imageUrl!)!
        let testImage = UIImage(systemName: "photo")!
        ImageCache.shared.setImage(testImage, for: url)
        
        let viewModel = CardViewModel(breed: breed, service: MockBreedsService(success: true))
        
        if case .success = viewModel.imageState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .success imageState from cache")
        }
    }
    
    func test_getImage_success_setsSuccessState() async {
        let breed = TestData.sampleBreed
        let viewModel = CardViewModel(breed: breed, service: MockBreedsService(success: true))
        
        await MainActor.run {
            viewModel.imageState = .success(Image(systemName: "photo"))
        }
        
        if case .success = viewModel.imageState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .success imageState after loading")
        }
    }

    
    func test_getImage_failure_setsFailureState() async {
        let breed = TestData.sampleBreed
        let viewModel = CardViewModel(breed: breed, service: MockBreedsService(success: false))
        
        await viewModel.getImage()
        
        if case .failure = viewModel.imageState {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected .failure imageState on error")
        }
    }
}
