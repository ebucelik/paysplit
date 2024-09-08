//
//  AccountService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.09.24.
//

import Foundation

protocol AccountServiceProtocol {
    func logout() async throws
}

class AccountService: APIClient, AccountServiceProtocol {
    func logout() async throws {
        _ = try await start(call: LogoutCall())
    }
}
