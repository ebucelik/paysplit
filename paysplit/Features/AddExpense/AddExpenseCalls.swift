//
//  AddExpenseCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 12.10.24.
//

import Foundation

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

struct AddExpensesCall: Call {
    typealias Parser = [Expense]
    let ressource: String = "v1/expense/add"
    var httpMethod: HttpMethod = .POST
    var body: Data?

    init(expenses: [Expense]) {
        do {
            self.body = try JSONEncoder().encode(expenses)
        } catch {
            print("Encoding failed.")
        }
    }
}
