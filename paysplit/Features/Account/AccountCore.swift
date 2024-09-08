//
//  AccountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AccountCore {
    @ObservableState
    struct State: Equatable {
        let accountState: ViewState<Account>
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case logout
    }

    let service: AccountServiceProtocol

    var body: some ReducerOf<AccountCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none

            case .logout:
                return .run { send in
                    _ = try await self.service.logout()
                } catch: { error, send in
                    if let error = error as? APIError,
                        error == .unauthorized {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .logout, object: nil)
                        }
                    }
                }
            }
        }
    }
}
