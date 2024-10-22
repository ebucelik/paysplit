//
//  FullAmountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FullAmountCore {
    @ObservableState
    struct State {
        var expenseDescription = ""
        var expenseAmount = ""

        let numberFormatter = NumberFormatter()

        var isExpensesAmountFulfilled: Bool {
            numberFormatter.decimalSeparator = ","
            numberFormatter.maximumFractionDigits = 2

            let expensesAmount = Float(
                String(
                    format: "%.2f",
                    numberFormatter.number(from: expenseAmount)?.floatValue ?? 0
                )
            )

            return (expensesAmount ?? 0) > 0
        }
    }

    enum Action: BindableAction {
        enum Delegate {
            case evaluateNextStep(String, String)
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
