//
//  AddPeopleCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.09.24.
//

import Foundation

struct AddPersonCall: Call {
    typealias Parser = MessageResponse
    let ressource: String = "v1/account/add"
    let httpMethod: HttpMethod = .POST
    let parameters: [String : Any]?

    init(
        firstId: Int,
        secondId: Int
    ) {
        parameters = [
            "firstId": "\(firstId)",
            "secondId": "\(secondId)"
        ]
    }
}

struct RemovePersonCall: Call {
    typealias Parser = MessageResponse
    let ressource: String = "v1/account/remove"
    let httpMethod: HttpMethod = .POST
    let parameters: [String : Any]?

    init(
        firstId: Int,
        secondId: Int
    ) {
        parameters = [
            "firstId": "\(firstId)",
            "secondId": "\(secondId)"
        ]
    }
}

struct GetAddedPeopleCall: Call {
    typealias Parser = [Account]
    let ressource: String = "v1/account/addedAccounts"
    let httpMethod: HttpMethod = .GET
    let parameters: [String : Any]?

    init(id: Int) {
        parameters = ["id": "\(id)"]
    }
}

struct SearchPeopleCall: Call {
    typealias Parser = [Account]
    let ressource: String = "v1/account/search"
    let httpMethod: HttpMethod = .GET
    let parameters: [String : Any]?

    init(
        id: Int,
        term: String
    ) {
        parameters = [
            "id": "\(id)",
            "term": term
        ]
    }
}
