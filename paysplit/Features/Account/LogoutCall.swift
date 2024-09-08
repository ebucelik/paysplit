//
//  LogoutCall.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.09.24.
//

import Foundation

struct LogoutCall: Call {
    typealias Parser = Logout
    let ressource: String = "v1/auth/logout"
    let httpMethod: HttpMethod = .POST
}

struct Logout: Decodable, Equatable {

}
