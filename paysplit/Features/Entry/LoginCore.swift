//
//  LoginCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct LoginCore {
    @ObservableState
    struct State: Equatable {
        var authorizationState: ViewState<AuthorizationToken> = .none
        var authenticationRequest: AuthenticationRequest = .empty

        var isAuthenticationRequestInvalid: Bool {
            authenticationRequest.username.isEmpty || authenticationRequest.password.isEmpty
        }
    }

    enum Action: BindableAction {
        enum Delegate {
            case showRegister
            case showOverview
        }

        case signIn
        case authorizationStateChanged(ViewState<AuthorizationToken>)
        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    @Dependency(\.entryService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .signIn:
                return .run { [state = state] send in
                    await send(.authorizationStateChanged(.loading))

                    let authorizationState = try await self.service.login(authenticationRequest: state.authenticationRequest)

                    await send(.authorizationStateChanged(.loaded(authorizationState)))
                } catch: { error, send in
                    await send(.authorizationStateChanged(.error(error as? MessageResponse ?? error)))
                }

            case let .authorizationStateChanged(authorizationState):
                state.authorizationState = authorizationState

                if case let .loaded(authorizationToken) = authorizationState {
                    UserDefaults.standard.set(authorizationToken.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(authorizationToken.refreshToken, forKey: "refreshToken")

                    do {
                        let accountData = try JSONEncoder().encode(authorizationToken.account)
                        UserDefaults.standard.set(accountData, forKey: "account")
                    } catch {
                        print("Encoding failed.")
                    }

                    return .send(.delegate(.showOverview))
                }

                return .none

            case .delegate, .binding:
                return .none
            }
        }
    }
}
