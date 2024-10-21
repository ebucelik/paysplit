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
    func deleteImage(link: String) async throws -> String
    func uploadImage(imageData: Data) async throws -> String
    func updatePictureLink(id: Int, link: String) async throws -> Account
    func getStatistics(id: Int) async throws -> AccountStatistics
}

class AccountService: APIClient, AccountServiceProtocol {
    func logout() async throws {
        _ = try await start(call: LogoutCall())
    }

    func deleteImage(link: String) async throws -> String {
        try await start(call: DeletePictureLinkCall(link: link))
    }

    func uploadImage(imageData: Data) async throws -> String {
        try await start(call: ImageCall(imageData: imageData))
    }

    func updatePictureLink(id: Int, link: String) async throws -> Account {
        try await start(call: UpdatePictureLinkCall(id: id, link: link))
    }

    func getStatistics(id: Int) async throws -> AccountStatistics {
        try await start(call: StatisticsCall(id: id))
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
