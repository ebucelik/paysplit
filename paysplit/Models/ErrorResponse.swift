//
//  ErrorResponse.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

struct ErrorResponse: Decodable, Equatable, Error {
    let message: String
}

extension Error {
    var asErrorResponse: ErrorResponse? {
        self as? ErrorResponse
    }
}
