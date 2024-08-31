//
//  LoginCall.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 31.08.24.
//

import Foundation

struct LoginCall: Call {
    typealias Parser = AuthorizationToken
    let httpMethod: HttpMethod = .POST
    let ressource: String = "v1/auth/login"
    var body: Data?

    init(body: AuthenticationRequest) {
        do {
            self.body = try JSONEncoder().encode(body)
        } catch {
            print("Encoding failed.")
        }
    }
}
