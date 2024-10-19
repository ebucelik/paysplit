//
//  OpenExpense.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 19.10.24.
//

import Foundation

struct OpenExpense: Codable, Hashable {
    let id: Int
    let creatorId: Int
    let debtorId: Int
    let creatorName: String
    let creatorUsername: String
    let creatorPictureLink: String
    let expenseDescription: String
    let expenseAmount: String
    let timestamp: Double

    init(
        id: Int,
        creatorId: Int,
        debtorId: Int,
        creatorName: String,
        creatorUsername: String,
        creatorPictureLink: String,
        expenseDescription: String,
        expenseAmount: String,
        timestamp: Double
    ) {
        self.id = id
        self.creatorId = creatorId
        self.debtorId = debtorId
        self.creatorName = creatorName
        self.creatorUsername = creatorUsername
        self.creatorPictureLink = creatorPictureLink
        self.expenseDescription = expenseDescription
        self.expenseAmount = expenseAmount
        self.timestamp = timestamp
    }
}
