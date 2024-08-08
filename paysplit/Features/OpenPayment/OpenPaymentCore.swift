//
//  OpenPaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer
struct OpenPaymentCore {
    @ObservableState
    struct State: Equatable {

    }

    @CasePathable
    enum Action {

    }

    var body: some ReducerOf<OpenPaymentCore> {
        Reduce { state, action in
            switch action {}
        }
    }
}
