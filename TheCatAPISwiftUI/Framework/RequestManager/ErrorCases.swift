//
//  ErrorCases.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//

import Foundation

enum ErrorCases: LocalizedError {
    case ivalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .ivalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received from server"
        }
    }
}
