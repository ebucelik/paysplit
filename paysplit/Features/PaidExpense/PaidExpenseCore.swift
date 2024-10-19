//
//  PaidExpenseCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer
struct PaidExpenseCore {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        var paidExpenses: ViewState<[PaidPaymentAccount]> = .none
    }

    enum Action {
        case onViewAppear
        case loadPaidExpenses
        case setPaidExpenses(ViewState<[PaidPaymentAccount]>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.paidExpenses == .none else { return .none }

                return .send(.loadPaidExpenses)

            case .loadPaidExpenses:
                return .run { [paidExpensesState = state.paidExpenses] send in
                    if case let .loaded(paidExpenses) = paidExpensesState {
                        await send(.setPaidExpenses(.refreshing(paidExpenses)))
                    } else {
                        await send(.setPaidExpenses(.loading))
                    }

                    try await Task.sleep(for: .seconds(1))

                    await send(.setPaidExpenses(.loaded(.mocks)))
                }

            case let .setPaidExpenses(paidExpenses):
                state.paidExpenses = paidExpenses

                return .none
            }
        }
    }
}
