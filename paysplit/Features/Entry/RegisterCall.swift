//
//  RegisterCall.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 31.08.24.
//

import Foundation

struct RegisterCall: Call {
    typealias Parser = Account
    let httpMethod: HttpMethod = .POST
    let ressource: String = "v1/account/register"
    var body: Data?

    init(body: RegisterRequest) {
        do {
            self.body = try JSONEncoder().encode(body)
        } catch {
            print("Encoding failed.")
        }
    }
}
