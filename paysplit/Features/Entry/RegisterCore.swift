//
//  RegisterCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture

@Reducer
struct RegisterCore {
    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        enum Delegate {
            case showLogin
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

