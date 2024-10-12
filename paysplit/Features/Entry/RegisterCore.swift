//
//  RegisterCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct RegisterCore {
    @ObservableState
    struct State: Equatable {
        var registerRequest: RegisterRequest = .empty
        var registrationState: ViewState<Account> = .none

        var passwordAgain: String = ""

        var isRegistrationRequestInvalid: Bool {
            registerRequest.firstname.isEmpty ||
            registerRequest.lastname.isEmpty ||
            registerRequest.username.isEmpty ||
            registerRequest.password.isEmpty ||
            passwordAgain.isEmpty ||
            registerRequest.password != passwordAgain
        }
    }

    enum Action: BindableAction {
        enum Delegate {
            case showLogin
            case showOverview
        }

        case signUp
        case registrationStateChanged(ViewState<Account>)

        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    @Dependency(\.entryService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .signUp:
                return .run { [state = state] send in
                    await send(.registrationStateChanged(.loading))

                    let account = try await self.service.register(registerRequest: state.registerRequest)

                    await send(.registrationStateChanged(.loaded(account)))
                } catch: { error, send in
                    await send(.registrationStateChanged(.error(error as? MessageResponse ?? error)))
                }

            case let .registrationStateChanged(registrationState):
                state.registrationState = registrationState

                if case let .loaded(account) = registrationState {
                    do {
                        let accountData = try JSONEncoder().encode(account)
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

