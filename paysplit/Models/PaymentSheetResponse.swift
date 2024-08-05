//
//  PaymentSheetResponse.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

struct PaymentSheetResponse: Codable, Equatable {
    let clientSecret: String
    let publishableKey: String

    init(
        clientSecret: String,
        publishableKey: String
    ) {
        self.clientSecret = clientSecret
        self.publishableKey = publishableKey
    }
}
