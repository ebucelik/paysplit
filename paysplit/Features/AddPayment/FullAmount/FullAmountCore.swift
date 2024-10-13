//
//  FullAmountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture

@Reducer
struct FullAmountCore {
    @ObservableState
    struct State {
        var expenseDescription = ""
        var expenseAmount = ""
    }

    enum Action: BindableAction {
        enum Delegate {
            case evaluateNextStep(String)
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
