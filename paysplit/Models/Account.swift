//
//  Account.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    struct BankDetail: Codable, Hashable {
        let iban: String
        let bic: String?
        let firstname: String
        let lastname: String
    }

    let id: Int
    let username: String
    let firstname: String
    let lastname: String
    let password: String?
    let picturelink: String
    let bankdetail: BankDetail?

    init(
        id: Int,
        username: String,
        firstname: String,
        lastname: String,
        password: String?,
        picturelink: String,
        bankdetail: BankDetail?
    ) {
        self.id = id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.password = password
        self.picturelink = picturelink
        self.bankdetail = bankdetail
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

    static var mock3: Account.BankDetail {
        Account.BankDetail(
            iban: "AT12 1428 8150 3109 2221",
            bic: "INATWIES",
            firstname: "Christoph",
            lastname: "Mihle"
        )
    }

    static var mock4: Account.BankDetail {
        Account.BankDetail(
            iban: "AT12 1112 8150 3109 2221",
            bic: "INATWIES",
            firstname: "Hakan",
            lastname: "Aktürk"
        )
    }

    static var mock5: Account.BankDetail {
        Account.BankDetail(
            iban: "AT12 1112 8150 0011 2221",
            bic: "INATWIES",
            firstname: "Abdullah",
            lastname: "Oguz"
        )
    }

    static var mock6: Account.BankDetail {
        Account.BankDetail(
            iban: "AT12 1112 8150 0011 1665",
            bic: "INATWIES",
            firstname: "Neymar",
            lastname: "Junior Aguero"
        )
    }
}
extension Account {
    static var mock: Account {
        Account(
            id: 0,
            username: "ebucelik",
            firstname: "Ebu",
            lastname: "Celik",
            password: nil,
            picturelink: "",
            bankdetail: .mock
        )
    }

    static var mock1: Account {
        Account(
            id: 1,
            username: "stefandjudic",
            firstname: "Stefan",
            lastname: "Djudic",
            password: nil,
            picturelink: "",
            bankdetail: .mock1
        )
    }

    static var mock2: Account {
        Account(
            id: 2,
            username: "haralotto",
            firstname: "Harald",
            lastname: "Otto",
            password: nil,
            picturelink: "",
            bankdetail: .mock2
        )
    }

    static var mock3: Account {
        Account(
            id: 3,
            username: "crisi",
            firstname: "Christoph",
            lastname: "Mihle",
            password: nil,
            picturelink: "",
            bankdetail: .mock3
        )
    }

    static var mock4: Account {
        Account(
            id: 4,
            username: "haki54",
            firstname: "Hakan",
            lastname: "Aktürk",
            password: nil,
            picturelink: "",
            bankdetail: .mock4
        )
    }

    static var mock5: Account {
        Account(
            id: 5,
            username: "abdul.zeyn",
            firstname: "Abdullah",
            lastname: "Oguz",
            password: nil,
            picturelink: "",
            bankdetail: .mock5
        )
    }

    static var mock6: Account {
        Account(
            id: 6,
            username: "neymar",
            firstname: "Neymar",
            lastname: "JR",
            password: nil,
            picturelink: "",
            bankdetail: .mock6
        )
    }
}

extension Sequence where Element == Account {
    static var mocks: [Account] {
        [
            .mock,
            .mock1,
            .mock2,
            .mock3,
            .mock4,
            .mock5,
            .mock6
        ]
    }
}
