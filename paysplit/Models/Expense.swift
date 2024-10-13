//
//  Expense.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

struct Expense: Codable, Hashable {
    var creatorId: Int
    var debtorId: Int
    var expenseDescription: String
    var expenseAmount: String
    var paid: Bool
    var timestamp: Double

    init(
        creatorId: Int,
        debtorId: Int,
        expenseDescription: String,
        expenseAmount: String,
        paid: Bool,
        timestamp: Double
    ) {
        self.creatorId = creatorId
        self.debtorId = debtorId
        self.expenseDescription = expenseDescription
        self.expenseAmount = expenseAmount
        self.paid = paid
        self.timestamp = timestamp
    }
}

extension Expense {
    static var empty = Expense(
        creatorId: 0,
        debtorId: 0,
        expenseDescription: "",
        expenseAmount: "",
        paid: false,
        timestamp: 0
    )
}
