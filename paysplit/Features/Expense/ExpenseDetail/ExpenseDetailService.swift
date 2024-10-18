//
//  ExpenseDetailService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

import ComposableArchitecture

protocol ExpenseDetailServiceProtocol {
    func getExpenses(
        id: Int,
        expenseDescription: String,
        timestamp: Double
    ) async throws -> [ExpenseDetail]
}

class ExpenseDetailService: APIClient, ExpenseDetailServiceProtocol {
    func getExpenses(
        id: Int,
        expenseDescription: String,
        timestamp: Double
    ) async throws -> [ExpenseDetail] {
        try await start(
            call: GetExpenseDetailCall(
                id: id,
                expenseDescription: expenseDescription,
                timestamp: timestamp
            )
        )
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
