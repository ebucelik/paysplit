//
//  AccountService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.09.24.
//

import Foundation
import ComposableArchitecture

protocol AccountServiceProtocol {
    func logout() async throws
}

class AccountService: APIClient, AccountServiceProtocol {
    func logout() async throws {
        _ = try await start(call: LogoutCall())
    }
}

enum AccountServiceKey: DependencyKey {
    static let liveValue: any AccountServiceProtocol = AccountService()
}

extension DependencyValues {
    var accountService: any AccountServiceProtocol {
        get { self[AccountServiceKey.self] }
        set { self[AccountServiceKey.self] = newValue }
    }
}
