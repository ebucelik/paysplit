//
//  AuthorizationToken.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.08.24.
//

import Foundation

struct AuthorizationToken: Decodable, Equatable {
    let accessToken: String
    let refreshToken: String
}
