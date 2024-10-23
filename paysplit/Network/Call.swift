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
    var imageData: Data? { get }
}

extension Call {
    var domain: String { Deployment.dev.rawValue }
    var path: String { domain + ressource }
    var body: Data? { nil }
    var parameters: [String: Any]? { nil }
    var imageData: Data? { nil }
}

enum Deployment: String {
    case dev = "http://localhost:8080/api/"
    case prod = "http://85.215.128.216:8082/api/"
}
