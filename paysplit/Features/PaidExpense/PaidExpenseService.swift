//
//  PaidExpenseService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

import ComposableArchitecture

protocol PaidExpenseServiceProtocol {
    func paidExpenses(id: Int) async throws -> [OpenPaidExpense]
    func updateExpense(id: Int, paid: Bool) async throws -> Expense
}

class PaidExpenseService: APIClient, PaidExpenseServiceProtocol {
    func paidExpenses(id: Int) async throws -> [OpenPaidExpense] {
        try await start(call: GetPaidExpenseCall(id: id))
    }

    func updateExpense(id: Int, paid: Bool) async throws -> Expense {
        try await start(call: UpdateOpenExpenseCall(id: id, paid: paid))
    }
}

enum PaidExpenseServiceKey: DependencyKey {
    static let liveValue: PaidExpenseServiceProtocol = PaidExpenseService()
}

extension DependencyValues {
    var paidExpenseService: PaidExpenseServiceProtocol {
        get { self[PaidExpenseServiceKey.self] }
        set { self[PaidExpenseServiceKey.self] = newValue }
    }
}
