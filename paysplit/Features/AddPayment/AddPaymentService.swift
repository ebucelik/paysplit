//
//  AddPaymentService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture

protocol AddPaymentServiceProtocol {
    func addExpenses(expenses: [Expense]) async throws -> [Expense]
}

class AddPaymentService: APIClient, AddPaymentServiceProtocol {
    func addExpenses(expenses: [Expense]) async throws -> [Expense] {
        try await start(call: AddExpensesCall(expenses: expenses))
    }
}

enum AddPaymentServiceKey: DependencyKey {
    static let liveValue: AddPaymentServiceProtocol = AddPaymentService()
}

extension DependencyValues {
    var addPaymentService: AddPaymentServiceProtocol {
        get { self[AddPaymentServiceKey.self] }
        set { self[AddPaymentServiceKey.self] = newValue }
    }
}
