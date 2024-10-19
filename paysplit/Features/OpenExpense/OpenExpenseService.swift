//
//  OpenExpenseService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//
import ComposableArchitecture

protocol OpenExpenseServiceProtocol {
    func openExpenses(debtorId: Int) async throws -> [OpenExpense]
}

class OpenExpenseService: APIClient, OpenExpenseServiceProtocol {
    func openExpenses(debtorId: Int) async throws -> [OpenExpense] {
        try await start(call: GetOpenExpenseCall(debtorId: debtorId))
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
