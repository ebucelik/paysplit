//
//  Call.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

protocol Call {
    associatedtype Parser: Decodable & Equatable

    var domain: String { get }
    var ressource: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var body: Data? { get }
    var parameters: [String: Any]? { get }
}

extension Call {
    var domain: String { "http://127.0.0.1:8080/api/" }
    var path: String { domain + ressource }
    var body: Data? { nil }
    var parameters: [String: Any]? { nil }
}
