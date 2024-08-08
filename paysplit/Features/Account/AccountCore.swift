//
//  AccountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer
struct AccountCore {
    @ObservableState
    struct State: Equatable {

    }

    @CasePathable
    enum Action {
        case onViewAppear
    }

    var body: some ReducerOf<AccountCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
