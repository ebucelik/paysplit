//
//  PaidPaymentAccount.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import Foundation

struct PaidPaymentAccount: Codable, Equatable, Identifiable {
    let id: String
    let firstname: String
    let lastname: String
    let username: String
    let image: String?
    let amount: String
    let currencyCode: String
    let transactionStatus: TransactionStatus
    let reason: String?

    enum TransactionStatus: Codable, Equatable {
        case pending
        case success
        case failure
    }

    init(
        id: String,
        firstname: String,
        lastname: String,
        username: String,
        image: String?,
        amount: String,
        currencyCode: String,
        transactionStatus: TransactionStatus,
        reason: String?
    ) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.image = image
        self.amount = amount
        self.currencyCode = currencyCode
        self.transactionStatus = transactionStatus
        self.reason = reason
    }
}

extension PaidPaymentAccount {
    static var mock: PaidPaymentAccount {
        PaidPaymentAccount(
            id: "0",
            firstname: "Stefan",
            lastname: "Djudic",
            username: "stefandjudic",
            image: nil,
            amount: "- 20,00",
            currencyCode: "EUR",
            transactionStatus: .pending,
            reason: "In the next day the transaction will be completed."
        )
    }

    static var mock1: PaidPaymentAccount {
        PaidPaymentAccount(
            id: "1",
            firstname: "Ebu",
            lastname: "Celik",
            username: "ebucelik",
            image: nil,
            amount: "- 261,71",
            currencyCode: "EUR",
            transactionStatus: .success,
            reason: nil
        )
    }

    static var mock2: PaidPaymentAccount {
        PaidPaymentAccount(
            id: "2",
            firstname: "Christoph",
            lastname: "Mihle",
            username: "crisi",
            image: nil,
            amount: "+ 6,75",
            currencyCode: "EUR",
            transactionStatus: .success,
            reason: nil
        )
    }

    static var mock3: PaidPaymentAccount {
        PaidPaymentAccount(
            id: "3",
            firstname: "Harald",
            lastname: "Otto",
            username: "haralotto",
            image: nil,
            amount: "+ 11,00",
            currencyCode: "EUR",
            transactionStatus: .failure,
            reason: "The recipient bank declined the transaction."
        )
    }

    static var mock4: PaidPaymentAccount {
        PaidPaymentAccount(
            id: "4",
            firstname: "Karl",
            lastname: "Koslick",
            username: "karlkoslick",
            image: nil,
            amount: "- 54,00",
            currencyCode: "EUR",
            transactionStatus: .pending,
            reason: "The transaction might take several days to complete."
        )
    }
}

extension Sequence where Element == PaidPaymentAccount {
    static var mocks: [PaidPaymentAccount] {
        [
            .mock,
            .mock1,
            .mock2,
            .mock3,
            .mock4
        ]
    }
}
