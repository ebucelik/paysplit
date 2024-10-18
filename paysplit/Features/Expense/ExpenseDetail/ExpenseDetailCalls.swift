//
//  ExpenseDetailCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

struct GetExpenseDetailCall: Call {
    typealias Parser = [Expense]

    var ressource: String = "api/v1/expense"
    var httpMethod: HttpMethod = .GET
    var parameters: [String : Any]?

    init(id: Int) {
        parameters = ["id": id]
    }
}
