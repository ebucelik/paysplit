//
//  ExpenseDetailCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

struct GetExpenseDetailCall: Call {
    typealias Parser = [ExpenseDetail]

    var ressource: String = "v1/expense/details"
    var httpMethod: HttpMethod = .GET
    var parameters: [String : Any]?

    init(
        id: Int,
        expenseDescription: String,
        timestamp: Double
    ) {
        parameters = [
            "id": id,
            "expenseDescription": expenseDescription,
            "timestamp": timestamp
        ]
    }
}
