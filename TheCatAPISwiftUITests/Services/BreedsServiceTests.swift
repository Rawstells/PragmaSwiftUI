//
//  BreedsServiceTests.swift
//  TheCatAPISwiftUITests
//
//  Created by joan on 10/04/25.
//

import XCTest
@testable import TheCatAPISwiftUI

final class BreedsServiceTests: XCTestCase {
    
    var service: BreedsService!
    
    override func setUp() {
        super.setUp()
        service = BreedsService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func test_fetchBreeds_returnsValidData() async throws {
        let breeds = try await service.fetchBreeds()
        
        XCTAssertFalse(breeds.isEmpty, "La respuesta de la API no debe estar vacía")
        XCTAssertNotNil(breeds.first?.name)
        XCTAssertNotNil(breeds.first?.id)
    }
    
    func test_fetchBreedImage_returnsValidURL() async throws {
        let referenceImageId = "0XYvRd7oD"
        let url = try await service.fetchBreedImage(id: referenceImageId)
        
        XCTAssertFalse(url.isEmpty, "El URL de imagen no debe estar vacío")
        XCTAssertTrue(url.contains("https://"), "Debe ser un URL válido")
    }
}
