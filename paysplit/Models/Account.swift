//
//  Account.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    let id: Int
    let username: String
    let firstname: String
    let lastname: String
    let password: String?
    let picturelink: String

    init(
        id: Int,
        username: String,
        firstname: String,
        lastname: String,
        password: String?,
        picturelink: String
    ) {
        self.id = id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.password = password
        self.picturelink = picturelink
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
            picturelink: ""
        )
    }

    static var mock1: Account {
        Account(
            id: 1,
            username: "stefandjudic",
            firstname: "Stefan",
            lastname: "Djudic",
            password: nil,
            picturelink: ""
        )
    }

    static var mock2: Account {
        Account(
            id: 2,
            username: "haralotto",
            firstname: "Harald",
            lastname: "Otto",
            password: nil,
            picturelink: ""
        )
    }

    static var mock3: Account {
        Account(
            id: 3,
            username: "crisi",
            firstname: "Christoph",
            lastname: "Mihle",
            password: nil,
            picturelink: ""
        )
    }

    static var mock4: Account {
        Account(
            id: 4,
            username: "haki54",
            firstname: "Hakan",
            lastname: "Aktürk",
            password: nil,
            picturelink: ""
        )
    }

    static var mock5: Account {
        Account(
            id: 5,
            username: "abdul.zeyn",
            firstname: "Abdullah",
            lastname: "Oguz",
            password: nil,
            picturelink: ""
        )
    }

    static var mock6: Account {
        Account(
            id: 6,
            username: "neymar",
            firstname: "Neymar",
            lastname: "JR",
            password: nil,
            picturelink: ""
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
