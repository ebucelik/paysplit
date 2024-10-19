//
//  OpenExpenseCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

struct GetOpenExpenseCall: Call {
    typealias Parser = [OpenExpense]

    var ressource: String = "v1/expense/open"
    var httpMethod: HttpMethod = .GET
    var parameters: [String : Any]?

    init(debtorId: Int) {
        parameters = ["id": debtorId]
    }
}
