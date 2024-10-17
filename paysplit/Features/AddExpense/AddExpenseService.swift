//
//  AddExpenseService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture

protocol AddExpenseServiceProtocol {
    func addExpenses(expenses: [Expense]) async throws -> [Expense]
}

class AddExpenseService: APIClient, AddExpenseServiceProtocol {
    func addExpenses(expenses: [Expense]) async throws -> [Expense] {
        try await start(call: AddExpensesCall(expenses: expenses))
    }
}

enum AddExpenseServiceKey: DependencyKey {
    static let liveValue: AddExpenseServiceProtocol = AddExpenseService()
}

extension DependencyValues {
    var addExpenseService: AddExpenseServiceProtocol {
        get { self[AddExpenseServiceKey.self] }
        set { self[AddExpenseServiceKey.self] = newValue }
    }
}
