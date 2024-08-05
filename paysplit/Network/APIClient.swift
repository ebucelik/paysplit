//
//  APIClient.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

class APIClient {
    func start<C: Call>(call: C) async throws -> C.Parser {
        guard var urlComponents = URLComponents(string: call.path) else { throw APIError.invalidUrl }

        if let parameters = call.parameters {
            urlComponents.queryItems = parameters.map { parameter in
                URLQueryItem(
                    name: parameter.key,
                    value: "\(parameter.value)"
                )
            }
        }

        guard let url = urlComponents.url else { throw APIError.invalidUrl }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = call.httpMethod.rawValue
        urlRequest.httpBody = call.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let response = try await URLSession.shared.data(for: urlRequest)

        guard let httpUrlResponse = response.1 as? HTTPURLResponse else { throw APIError.response }

        if isStatusCodeOk(code: httpUrlResponse.statusCode) {
            return try JSONDecoder().decode(C.Parser.self, from: response.0)
        } else if isStatusCodeNotOk(code: httpUrlResponse.statusCode) {
            do {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.0)

                throw APIError.requestFailed(errorResponse)
            } catch {
                throw APIError.requestFailed(error)
            }
        }

        throw APIError.general
    }

    private func isStatusCodeOk(code: Int) -> Bool {
        (200...399).contains(code)
    }

    private func isStatusCodeNotOk(code: Int) -> Bool {
        (400...599).contains(code)
    }
}
