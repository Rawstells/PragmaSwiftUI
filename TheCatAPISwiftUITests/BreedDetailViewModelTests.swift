//
//  BreedDetailViewModelTests.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import XCTest
@testable import TheCatAPISwiftUI

final class BreedDetailViewModelTests: XCTestCase {
    
    func test_loadAdditionalImages_success() async {
        let mockLoader = MockImageLoader(success: true)
        let viewModel = await BreedDetailViewModel(imageLoader: mockLoader)
        
        await viewModel.loadAdditionalImages(breedId: "abys")
        
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.additionalImages.count, 3)
            XCTAssertNil(viewModel.error)
        }
    }
    
    func test_loadAdditionalImages_failure() async {
        let mockLoader = MockImageLoader(success: false)
        let viewModel = await BreedDetailViewModel(imageLoader: mockLoader)
        
        await viewModel.loadAdditionalImages(breedId: "abys")
        
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.additionalImages.isEmpty)
            XCTAssertNotNil(viewModel.error)
        }
    }
    
    func test_selectImage_setsCorrectIndex() async {
        let viewModel = await BreedDetailViewModel()
        
        await MainActor.run {
            viewModel.selectImage(at: 2)
            XCTAssertEqual(viewModel.selectedImageIndex, 2)
        }
    }
    
    func test_setupLoadingAnimation_updatesPawOpacity() async {
        let viewModel = await BreedDetailViewModel()
        await MainActor.run {
            viewModel.setupLoadingAnimation()
        }
        
        let expectation = XCTestExpectation(description: "Paw animation finished")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            Task {
                await MainActor.run {
                    XCTAssertEqual(viewModel.pawLoadingOpacity, [1.0, 0.5, 0.3])
                    expectation.fulfill()
                }
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
