//
//  PaymentSheetCall.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

struct PaymentSheetCall: Call {
    typealias Parser = PaymentSheetResponse

    let ressource: String = "v1/payment/create-payment-intent"
    let httpMethod: HttpMethod = .POST
}
