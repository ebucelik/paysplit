//
//  EntryCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture

@Reducer
struct EntryCore {
    @ObservableState
    struct State: Equatable {
        @Presents var login: LoginCore.State?
        @Presents var register: RegisterCore.State?
    }

    @CasePathable
    enum Action {
        case showLogin
        case showRegister
        case login(PresentationAction<LoginCore.Action>)
        case register(PresentationAction<RegisterCore.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showLogin:
                state.login = LoginCore.State()

                return .none

            case .showRegister:
                state.register = RegisterCore.State()

                return .none
                
            case let .login(.presented(action)):
                switch action {

                }

                return .none

            case .login(.dismiss):
                return .none

            case let .register(.presented(action)):
                switch action {

                }

                return .none

            case .register(.dismiss):
                return .none
            }
        }
        .ifLet(\.$login, action: \.login) {
            LoginCore()
        }
        .ifLet(\.$register, action: \.register) {
            RegisterCore()
        }
    }
}
