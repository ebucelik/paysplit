//
//  SplitAmountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture

@Reducer
struct SplitAmountCore {
    @ObservableState
    struct State {
        var fullAmount: String
        var addedPeople: [Account]
    }

    enum Action: BindableAction {
        enum Delegate {
            case evaluateNextStep
        }

        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .delegate, .binding:
                return .none
            }
        }
    }
}
