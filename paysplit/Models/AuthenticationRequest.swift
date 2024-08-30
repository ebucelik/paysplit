//
//  AuthenticationRequest.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 30.08.24.
//

import Foundation

struct AuthenticationRequest: Codable, Equatable {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension AuthenticationRequest {
    static var empty: AuthenticationRequest {
        AuthenticationRequest(username: "", password: "")
    }
}
