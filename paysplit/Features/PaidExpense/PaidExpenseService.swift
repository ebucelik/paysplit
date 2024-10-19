//
//  PaidExpenseService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

import ComposableArchitecture

protocol PaidExpenseServiceProtocol {
    func paidExpenses(id: Int) async throws -> [OpenPaidExpense]
}

class PaidExpenseService: APIClient, PaidExpenseServiceProtocol {
    func paidExpenses(id: Int) async throws -> [OpenPaidExpense] {
        try await start(call: GetPaidExpenseCall(id: id))
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
