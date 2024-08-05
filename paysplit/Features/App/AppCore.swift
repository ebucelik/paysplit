//
//  AppCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import ComposableArchitecture

@Reducer
struct AppCore {
    @ObservableState
    struct State: Equatable {

    }

    @CasePathable
    enum Action {
        case onViewAppear
    }

    var body: some ReducerOf<AppCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
