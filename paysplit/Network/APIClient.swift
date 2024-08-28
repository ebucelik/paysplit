//
//  APIClient.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

class APIClient: NSObject, URLSessionTaskDelegate {
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

        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let response = try await URLSession.shared.data(for: urlRequest)

        guard let httpUrlResponse = response.1 as? HTTPURLResponse else { throw APIError.response }

        if let cookies = HTTPCookieStorage.shared.cookies,
           let sidCookie = cookies.first(where: { $0.name == "sid" }) {
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                if sidCookie.value != accessToken {
                    UserDefaults.standard.set(sidCookie.value, forKey: "accessToken")
                }
            }
        } else {
            UserDefaults.standard.set(nil, forKey: "accessToken")
        }

        if isStatusCodeOk(code: httpUrlResponse.statusCode) {
            return try JSONDecoder().decode(C.Parser.self, from: response.0)
        } else if isStatusCodeNotOk(code: httpUrlResponse.statusCode) {
            if httpUrlResponse.statusCode == 401 {
                // If refresh access token call also returns 401.
                if url.absoluteString.contains("auth/refresh") {
                    throw APIError.unauthorized
                }

                guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
                else { throw APIError.unauthorized }

                let authorizationToken = try await start(
                    call: RefreshAccessTokenCall(
                        refreshToken: refreshToken
                    )
                )

                UserDefaults.standard.set(authorizationToken.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(authorizationToken.refreshToken, forKey: "refreshToken")

                throw APIError.general
            } else {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.0)

                    throw APIError.requestFailed(errorResponse)
                } catch {
                    throw APIError.requestFailed(error)
                }
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
