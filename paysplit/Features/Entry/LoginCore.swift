//
//  LoginCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture

@Reducer
struct LoginCore {
    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        enum Delegate {
            case showRegister
        }

        case delegate(Delegate)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
}
