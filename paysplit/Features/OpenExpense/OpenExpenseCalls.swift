//
//  OpenExpenseCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

struct GetOpenExpenseCall: Call {
    typealias Parser = [OpenPaidExpense]

    var ressource: String = "v1/expense/open"
    var httpMethod: HttpMethod = .GET
    var parameters: [String : Any]?

    init(id: Int) {
        parameters = ["id": id]
    }
}

struct UpdateOpenExpenseCall: Call {
    typealias Parser = Expense

    var ressource: String = "v1/expense"
    var httpMethod: HttpMethod = .PUT
    var parameters: [String : Any]?

    init(
        id: Int,
        paid: Bool
    ) {
        parameters = [
            "id": id,
            "paid": paid
        ]
    }
}
