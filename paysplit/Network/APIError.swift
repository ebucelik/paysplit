//
//  APIError.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

enum APIError: Error {
    case decoding
    case response
    case invalidRequest
    case invalidUrl
    case requestFailed(Error)
    case unauthorized
    case general
}
