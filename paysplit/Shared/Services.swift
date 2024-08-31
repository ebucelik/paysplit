//
//  Services.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

class Services {
    static var appService: AppServiceProtocol {
        AppService()
    }

    static var paymentSheetService: PaymentSheetServiceProtocol {
        PaymentSheetService()
    }

    static var entryService: EntryServiceProtocol {
        EntryService()
    }
}
