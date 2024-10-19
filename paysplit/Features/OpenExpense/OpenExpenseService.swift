//
//  OpenExpenseService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

import ComposableArchitecture

protocol OpenExpenseServiceProtocol {
    func openExpenses(id: Int) async throws -> [OpenPaidExpense]
    func updateExpense(id: Int, paid: Bool) async throws -> Expense
}

class OpenExpenseService: APIClient, OpenExpenseServiceProtocol {
    func openExpenses(id: Int) async throws -> [OpenPaidExpense] {
        try await start(call: GetOpenExpenseCall(id: id))
    }

    func updateExpense(id: Int, paid: Bool) async throws -> Expense {
        try await start(call: UpdateOpenExpenseCall(id: id, paid: paid))
    }
}

enum OpenExpenseServiceKey: DependencyKey {
    static let liveValue: OpenExpenseServiceProtocol = OpenExpenseService()
}

extension DependencyValues {
    var openExpenseService: OpenExpenseServiceProtocol {
        get { self[OpenExpenseServiceKey.self] }
        set { self[OpenExpenseServiceKey.self] = newValue }
    }
}
