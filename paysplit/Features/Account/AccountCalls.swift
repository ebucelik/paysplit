//
//  AccountCalls.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

import Foundation

struct LogoutCall: Call {
    typealias Parser = Logout
    let ressource: String = "v1/auth/logout"
    let httpMethod: HttpMethod = .POST
}

struct Logout: Decodable, Equatable {

}

struct UpdatePictureLinkCall: Call {
    typealias Parser = Account
    let ressource: String = "v1/account/pictureLink"
    let httpMethod: HttpMethod = .PUT
    let parameters: [String : Any]?

    init(
        id: Int,
        link: String
    ) {
        parameters = [
            "id": id,
            "link": link
        ]
    }
}

struct DeletePictureLinkCall: Call {
    typealias Parser = String
    let ressource: String = "v1/image"
    let httpMethod: HttpMethod = .DELETE
    let parameters: [String : Any]?

    init(link: String) {
        parameters = [
            "link": link
        ]
    }
}

struct ImageCall: Call {
    typealias Parser = String

    let ressource: String = "v1/image"
    let httpMethod: HttpMethod = .POST
    let imageData: Data?

    init(imageData: Data) {
        self.imageData = imageData
    }
}

struct StatisticsCall: Call {
    typealias Parser = AccountStatistics
    let ressource: String = "v1/account/statistics"
    let httpMethod: HttpMethod = .GET
    let parameters: [String : Any]?

    init(id: Int) {
        parameters = [
            "id": id
        ]
    }
}
