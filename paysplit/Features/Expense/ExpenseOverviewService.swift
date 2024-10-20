//
//  ExpenseOverviewService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 17.10.24.
//

import ComposableArchitecture

protocol ExpenseOverviewServiceProtocol {
    func getGroupedExpenses(id: Int) async throws -> [Expense]
}

class ExpenseOverviewService: APIClient, ExpenseOverviewServiceProtocol {
    func getGroupedExpenses(id: Int) async throws -> [Expense] {
        try await start(call: GetGroupedExpenseCall(id: id))
    }
}

enum ExpenseOverviewServiceKey: DependencyKey {
    static let liveValue: ExpenseOverviewServiceProtocol = ExpenseOverviewService()
}

extension DependencyValues {
    var expenseOverviewService: ExpenseOverviewServiceProtocol {
        get { self[ExpenseOverviewServiceKey.self] }
        set { self[ExpenseOverviewServiceKey.self] = newValue }
    }
}
