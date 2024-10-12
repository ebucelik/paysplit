//
//  AddPaymentCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 12.10.24.
//

struct SearchAddedPeopleCall: Call {
    typealias Parser = [Account]
    let ressource: String = "v1/account/searchAddedAccounts"
    let httpMethod: HttpMethod = .GET
    let parameters: [String : Any]?

    init(
        id: Int,
        term: String
    ) {
        self.parameters = [
            "id": "\(id)",
            "term": term
        ]
    }
}
