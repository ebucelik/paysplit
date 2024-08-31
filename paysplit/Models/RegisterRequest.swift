//
//  RegisterRequest.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 31.08.24.
//

import Foundation

struct RegisterRequest: Codable, Equatable {
    struct BankDetail: Codable, Equatable {
        let iban: String
        let bic: String?
        let firstname: String
        let lastname: String
    }

    var username: String
    var firstname: String
    var lastname: String
    var password: String
    var picturelink: String
    let bankDetail: BankDetail?

    init(
        username: String,
        firstname: String,
        lastname: String,
        password: String,
        picturelink: String,
        bankDetail: BankDetail?
    ) {
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.password = password
        self.picturelink = picturelink
        self.bankDetail = bankDetail
    }
}

extension RegisterRequest {
    static var empty: RegisterRequest {
        RegisterRequest(
            username: "",
            firstname: "",
            lastname: "",
            password: "",
            picturelink: "",
            bankDetail: nil
        )
    }
}
