//
//  ExpenseOverviewCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 17.10.24.
//

struct GetGroupedExpenseCall: Call {
    typealias Parser = [Expense]
    
    var ressource: String = "v1/expense/grouped"
    var httpMethod: HttpMethod = .GET
    var parameters: [String : Any]?

    init(id: Int) {
        parameters = ["id": id]
    }
}
