//
//  AddPaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import ComposableArchitecture

@Reducer
struct AddPaymentCore {
    @ObservableState
    struct State: Equatable {

    }

    @CasePathable
    enum Action {
        case onViewAppear
    }

    var body: some ReducerOf<AddPaymentCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none
            }
        }
    }
}
