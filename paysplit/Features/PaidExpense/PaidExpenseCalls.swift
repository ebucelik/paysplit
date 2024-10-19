//
//  PaidExpenseCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

struct GetPaidExpenseCall: Call {
    typealias Parser = [OpenPaidExpense]

    var ressource: String = "v1/expense/paid"
    var httpMethod: HttpMethod = .GET
    var parameters: [String : Any]?

    init(id: Int) {
        parameters = ["id": id]
    }
}
