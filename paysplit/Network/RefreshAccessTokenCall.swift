//
//  RefreshAccessTokenCall.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.08.24.
//

import Foundation

struct RefreshAccessTokenCall: Call {
    typealias Parser = AuthorizationToken

    let ressource: String = "v1/auth/refresh"
    let httpMethod: HttpMethod = .POST
    var body: Data?

    init(refreshToken: String) {
        do {
            self.body = try JSONEncoder().encode(RefreshAccessTokenRequest(token: refreshToken))
        } catch {
            fatalError("Could not encode refresh token.")
        }
    }
}
