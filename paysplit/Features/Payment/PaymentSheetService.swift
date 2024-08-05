//
//  PaymentSheetService.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

protocol PaymentSheetServiceProtocol {
    func createPaymentSheet() async throws -> PaymentSheetResponse
}

class PaymentSheetService: APIClient, PaymentSheetServiceProtocol {
    func createPaymentSheet() async throws -> PaymentSheetResponse {
        try await start(call: PaymentSheetCall())
    }
}
