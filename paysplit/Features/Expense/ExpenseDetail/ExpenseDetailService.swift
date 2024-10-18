//
//  ExpenseDetailService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

import ComposableArchitecture

protocol ExpenseDetailServiceProtocol {
    func getExpenses(id: Int) async throws -> [Expense]
}

class ExpenseDetailService: APIClient, ExpenseDetailServiceProtocol {
    func getExpenses(id: Int) async throws -> [Expense] {
        try await start(call: GetExpenseDetailCall(id: id))
    }
}

enum ExpenseDetailServiceKey: DependencyKey {
    static let liveValue: ExpenseDetailServiceProtocol = ExpenseDetailService()
}

extension DependencyValues {
    var expenseDetailService: ExpenseDetailServiceProtocol {
        get { self[ExpenseDetailServiceKey.self] }
        set { self[ExpenseDetailServiceKey.self] = newValue }
    }
}
