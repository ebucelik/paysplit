//
//  ViewState.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import Foundation

enum ViewState<Item: Decodable & Equatable>: Equatable {
    case none
    case loading
    case refreshing(Item)
    case loaded(Item)
    case error(Error)

    static func == (lhs: ViewState<Item>, rhs: ViewState<Item>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case let (.refreshing(itemLhs), .refreshing(itemRhs)):
            return itemLhs == itemRhs
        case let (.loaded(itemLhs), .loaded(itemRhs)):
            return itemLhs == itemRhs
        case let (.error(errorLhs), .error(errorRhs)):
            return errorLhs.localizedDescription == errorRhs.localizedDescription
        default:
            return false
        }
    }
}
