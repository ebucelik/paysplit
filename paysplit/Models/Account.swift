//
//  Account.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import Foundation

struct Account: Codable, Equatable, Identifiable {
    struct BankDetail: Codable, Equatable {
        let iban: String
        let bic: String?
        let firstname: String
        let lastname: String
    }

    let id: String
    let username: String
    let firstname: String
    let lastname: String
    let password: String?
    let image: String?
    let bankDetail: BankDetail?

    init(
        id: String,
        username: String,
        firstname: String,
        lastname: String,
        password: String?,
        image: String?,
        bankDetail: BankDetail?
    ) {
        self.id = id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.password = password
        self.image = image
        self.bankDetail = bankDetail
    }
}

extension Account.BankDetail {
    static var mock: Account.BankDetail {
        Account.BankDetail(
            iban: "AT41 5212 3216 7712 1009",
            bic: "RLNWATWWW",
            firstname: "Ebu Bekir",
            lastname: "Celik"
        )
    }

    static var mock1: Account.BankDetail {
        Account.BankDetail(
            iban: "AT11 2291 1117 7712 1009",
            bic: "BLNWWATB",
            firstname: "Stefan",
            lastname: "Djudic"
        )
    }

    static var mock2: Account.BankDetail {
        Account.BankDetail(
            iban: "AT32 1428 8150 3109 2221",
            bic: "INATWIES",
            firstname: "Harald",
            lastname: "Otto"
        )
    }
}
extension Account {
    static var mock: Account {
        Account(
            id: "0",
            username: "ebucelik",
            firstname: "Ebu",
            lastname: "Celik",
            password: nil,
            image: nil,
            bankDetail: .mock
        )
    }

    static var mock1: Account {
        Account(
            id: "1",
            username: "stefandjudic",
            firstname: "Stefan",
            lastname: "Djudic",
            password: nil,
            image: nil,
            bankDetail: .mock1
        )
    }

    static var mock2: Account {
        Account(
            id: "2",
            username: "haralotto",
            firstname: "Harald",
            lastname: "Otto",
            password: nil,
            image: nil,
            bankDetail: .mock2
        )
    }
}

extension Sequence where Element == Account {
    static var mocks: [Account] {
        [
            .mock,
            .mock1,
            .mock2
        ]
    }
}
