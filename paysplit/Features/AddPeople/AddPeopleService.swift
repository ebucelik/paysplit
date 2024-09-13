//
//  AddPeopleService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.09.24.
//

import Foundation

protocol AddPeopleServiceProtocol {
    func addPerson(firstId: Int, secondId: Int) async throws -> MessageResponse
    func removePerson(firstId: Int, secondId: Int) async throws -> MessageResponse
    func getAddedPeople(id: Int) async throws -> [Account]
    func searchPeople(id: Int, term: String) async throws -> [Account]
}

class AddPeopleService: APIClient, AddPeopleServiceProtocol {
    func addPerson(
        firstId: Int,
        secondId: Int
    ) async throws -> MessageResponse {
        return try await start(
            call: AddPersonCall(
                firstId: firstId,
                secondId: secondId
            )
        )
    }

    func removePerson(
        firstId: Int,
        secondId: Int
    ) async throws -> MessageResponse {
        return try await start(
            call: RemovePersonCall(
                firstId: firstId,
                secondId: secondId
            )
        )
    }

    func getAddedPeople(id: Int) async throws -> [Account] {
        return try await start(call: GetAddedPeopleCall(id: id))
    }

    func searchPeople(
        id: Int,
        term: String
    ) async throws -> [Account] {
        return try await start(
            call: SearchPeopleCall(
                id: id,
                term: term
            )
        )
    }
}
