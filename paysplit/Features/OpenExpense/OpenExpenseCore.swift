//
//  OpenExpenseCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer
struct OpenExpenseCore {
    @ObservableState
    struct State: Equatable {
        var openExpenses: ViewState<[OpenPaymentAccount]> = .none
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case loadOpenExpenses
        case setOpenExpenses(ViewState<[OpenPaymentAccount]>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.openExpenses == .none else { return .none }

                return .send(.loadOpenExpenses)

            case .loadOpenExpenses:
                return .run { [openExpensesState = state.openExpenses] send in
                    if case let .loaded(openExpenses) = openExpensesState {
                        await send(.setOpenExpenses(.refreshing(openExpenses)))
                    } else {
                        await send(.setOpenExpenses(.loading))
                    }

                    try await Task.sleep(for: .seconds(1))

                    await send(.setOpenExpenses(.loaded(.init())))
                }

            case let .setOpenExpenses(openExpenses):
                state.openExpenses = openExpenses

                return .none
            }
        }
    }
}
