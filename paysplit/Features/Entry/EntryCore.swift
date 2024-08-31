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
        enum Delegate {
            case showOverview
        }

        case onViewAppear
        case showLogin
        case showRegister
        case login(PresentationAction<LoginCore.Action>)
        case register(PresentationAction<RegisterCore.Action>)
        case delegate(Delegate)
    }

    let service: EntryServiceProtocol

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                state.login = LoginCore.State()
                
                return .none

            case .showLogin:
                state.register = nil
                state.login = LoginCore.State()

                return .none

            case .showRegister:
                state.login = nil
                state.register = RegisterCore.State()

                return .none
                
            case let .login(.presented(action)):
                switch action {
                case .delegate(.showRegister):
                    return .send(.showRegister)

                case .delegate(.showOverview):
                    return .send(.delegate(.showOverview))

                default:
                    return .none
                }

            case .login(.dismiss):
                return .none

            case let .register(.presented(action)):
                switch action {
                case .delegate(.showLogin):
                    return .send(.showLogin)

                case .delegate(.showOverview):
                    return .send(.delegate(.showOverview))

                default:
                    return .none
                }

            case .register(.dismiss):
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$login, action: \.login) {
            LoginCore(service: service)
        }
        .ifLet(\.$register, action: \.register) {
            RegisterCore(service: service)
        }
    }
}
