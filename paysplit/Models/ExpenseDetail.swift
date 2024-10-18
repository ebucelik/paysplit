//
//  ExpenseDetail.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

import Foundation

struct ExpenseDetail: Codable, Hashable {
    let id: Int
    let creatorId: Int
    let debtorId: Int
    let debtorName: String
    let debtorUsername: String
    let debtorPictureLink: String
    let expenseAmount: String
    let paid: Bool
    let timestamp: Double

    init(
        id: Int,
        creatorId: Int,
        debtorId: Int,
        debtorName: String,
        debtorUsername: String,
        debtorPictureLink: String,
        expenseAmount: String,
        paid: Bool,
        timestamp: Double
    ) {
        self.id = id
        self.creatorId = creatorId
        self.debtorId = debtorId
        self.debtorName = debtorName
        self.debtorUsername = debtorUsername
        self.debtorPictureLink = debtorPictureLink
        self.expenseAmount = expenseAmount
        self.paid = paid
        self.timestamp = timestamp
    }
}
