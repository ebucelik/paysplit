//
//  SplitAmountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SplitAmountCore {
    @ObservableState
    struct State {
        var account: Account?
        var expenseDescription: String
        var expenseAmount: String
        var addedPeople: [Account]

        var expenses: [Expense]

        init(
            account: Account?,
            expenseDescription: String,
            expenseAmount: String,
            addedPeople: [Account]
        ) {
            self.expenseDescription = expenseDescription
            self.expenseAmount = expenseAmount
            self.addedPeople = addedPeople

            let timestamp = Date.now.timeIntervalSinceReferenceDate

            self.expenses = addedPeople.map { person in
                Expense(
                    creatorId: account?.id ?? 0,
                    debtorId: person.id,
                    expenseDescription: expenseDescription,
                    expenseAmount: "",
                    paid: false,
                    timestamp: timestamp
                )
            }
        }
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
