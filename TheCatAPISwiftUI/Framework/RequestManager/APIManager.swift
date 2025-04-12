//
//  APIManager.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Decodable>(
        url: String,
        httpMethod: String,
        headers: [String: String]?,
        requestBody: Encodable?
    ) async throws -> T
}

class APIManager: APIManagerProtocol {
    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case requestFailed(statusCode: Int, message: String?)
        case decodingFailed
        case missingData
        case custom(message: String)
        
        var errorDescription: String? {
            APIManager.APIError.debugError(self)
            switch self {
            case .invalidURL:
                return "URL inválida. Verifica la URL proporcionada."
            case .requestFailed(let statusCode, let message):
                return "Error en la solicitud. Código: \(statusCode). Mensaje: \(message ?? "Sin detalles")"
            case .decodingFailed:
                return "Error al decodificar la respuesta. Verifica el modelo de datos."
            case .missingData:
                return "No se recibieron datos en la respuesta."
            case .custom(let message):
                return message
            }
        }

        private static func debugError(_ error: Error) {
            #if DEBUG
                print("❌ \(error.localizedDescription)")
            #endif
        }
    }
    
    func request<T: Decodable>(
        url: String,
        httpMethod: String = "GET",
        headers: [String: String]? = nil,
        requestBody: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = requestBody {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.custom(message: "Error al codificar el body: \(error.localizedDescription)")
            }
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw APIError.custom(message: "Error en la conexión: \(error.localizedDescription)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(statusCode: -1, message: "Respuesta no válida")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Sin mensaje de error"
            throw APIError.requestFailed(
                statusCode: httpResponse.statusCode,
                message: "Error \(httpResponse.statusCode): \(errorMessage)"
            )
        }
        
        guard !data.isEmpty else {
            throw APIError.missingData
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
