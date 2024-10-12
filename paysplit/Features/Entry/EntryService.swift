//
//  EntryService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 31.08.24.
//

import Foundation
import ComposableArchitecture

protocol EntryServiceProtocol {
    func login(authenticationRequest: AuthenticationRequest) async throws -> AuthorizationToken
    func register(registerRequest: RegisterRequest) async throws -> Account
}

class EntryService: APIClient, EntryServiceProtocol {
    func login(authenticationRequest: AuthenticationRequest) async throws -> AuthorizationToken {
        try await start(call: LoginCall(body: authenticationRequest))
    }

    func register(registerRequest: RegisterRequest) async throws -> Account {
        try await start(call: RegisterCall(body: registerRequest))
    }
}

enum EntryServiceKey: DependencyKey {
    static let liveValue: any EntryServiceProtocol = EntryService()
}

extension DependencyValues {
    var entryService: EntryServiceProtocol {
        get { self[EntryServiceKey.self] }
        set { self[EntryServiceKey.self] = newValue }
    }
}
