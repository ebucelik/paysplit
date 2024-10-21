//
//  AccountStatistics.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 21.10.24.
//

struct AccountStatistics: Codable, Equatable {
    let addedFriends: Int
    let addedExpenses: Int
    let paidDebts: String
    let openDebts: String
    let receivedDebts: String
    let expectedDebts: String
    let highestReceivedDebt: String
    let highestPaidDebt: String

    init(
        addedFriends: Int,
        addedExpenses: Int,
        paidDebts: String,
        openDebts: String,
        receivedDebts: String,
        expectedDebts: String,
        highestReceivedDebt: String,
        highestPaidDebt: String
    ) {
        self.addedFriends = addedFriends
        self.addedExpenses = addedExpenses
        self.paidDebts = paidDebts
        self.openDebts = openDebts
        self.receivedDebts = receivedDebts
        self.expectedDebts = expectedDebts
        self.highestReceivedDebt = highestReceivedDebt
        self.highestPaidDebt = highestPaidDebt
    }
}
