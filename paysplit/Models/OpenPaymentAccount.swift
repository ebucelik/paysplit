//
//  OpenPaymentAccount.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import Foundation

struct OpenPaymentAccount: Codable, Equatable, Identifiable {
    let id: String
    let firstname: String
    let lastname: String
    let username: String
    let image: String?
    let amount: String
    let currencyCode: String
    let expectsPayment: Bool // If true, user who gets this object needs to pay.
    let paid: Bool

    init(
        id: String,
        firstname: String,
        lastname: String,
        username: String,
        image: String?,
        amount: String,
        currencyCode: String,
        expectsPayment: Bool,
        paid: Bool
    ) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.image = image
        self.amount = amount
        self.currencyCode = currencyCode
        self.expectsPayment = expectsPayment
        self.paid = paid
    }
}

extension OpenPaymentAccount {
    static var mock: OpenPaymentAccount {
        OpenPaymentAccount(
            id: "0",
            firstname: "Stefan",
            lastname: "Djudic",
            username: "stefandjudic",
            image: nil,
            amount: "- 20,00",
            currencyCode: "EUR",
            expectsPayment: true,
            paid: false
        )
    }

    static var mock1: OpenPaymentAccount {
        OpenPaymentAccount(
            id: "1",
            firstname: "Ebu",
            lastname: "Celik",
            username: "ebucelik",
            image: nil,
            amount: "- 261,71",
            currencyCode: "EUR",
            expectsPayment: true,
            paid: false
        )
    }

    static var mock2: OpenPaymentAccount {
        OpenPaymentAccount(
            id: "2",
            firstname: "Christoph",
            lastname: "Mihle",
            username: "crisi",
            image: nil,
            amount: "+ 6,75",
            currencyCode: "EUR",
            expectsPayment: false,
            paid: false
        )
    }

    static var mock3: OpenPaymentAccount {
        OpenPaymentAccount(
            id: "3",
            firstname: "Harald",
            lastname: "Otto",
            username: "haralotto",
            image: nil,
            amount: "+ 11,00",
            currencyCode: "EUR",
            expectsPayment: false,
            paid: false
        )
    }

    static var mock4: OpenPaymentAccount {
        OpenPaymentAccount(
            id: "4",
            firstname: "Karl",
            lastname: "Koslick",
            username: "karlkoslick",
            image: nil,
            amount: "- 54,00",
            currencyCode: "EUR",
            expectsPayment: true,
            paid: false
        )
    }
}

extension Sequence where Element == OpenPaymentAccount {
    static var mocks: [OpenPaymentAccount] {
        [
            .mock,
            .mock1,
            .mock2,
            .mock3,
            .mock4
        ]
    }
}
