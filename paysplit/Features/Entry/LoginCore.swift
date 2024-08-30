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
        var accountState: ViewState<Account> = .none
        var authenticationRequest: AuthenticationRequest = .empty

        var isAuthenticationRequestEmpty: Bool {
            authenticationRequest.username.isEmpty || authenticationRequest.password.isEmpty
        }
    }

    enum Action: BindableAction {
        enum Delegate {
            case showRegister
        }

        case signIn
        case accountStateChanged(ViewState<Account>)
        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .signIn:

                return .none

            case let .accountStateChanged(accountState):
                state.accountState = accountState

                return .none

            case .delegate, .binding:
                return .none
            }
        }
    }
}
