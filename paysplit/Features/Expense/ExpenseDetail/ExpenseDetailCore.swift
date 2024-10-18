//
//  ExpenseDetailCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

import ComposableArchitecture

@Reducer
struct ExpenseDetailCore {
    @ObservableState
    struct State {
        var account: Account?
        var expenseDetails: ViewState<[ExpenseDetail]> = .none
        var expense: Expense
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case loadExpenseDetails
        case setExpenseDetails(ViewState<[ExpenseDetail]>)
    }

    @Dependency(\.expenseDetailService) var service

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .send(.loadExpenseDetails)

            case .loadExpenseDetails:
                guard let account = state.account else { return .none }

                return .run { [
                    id = account.id,
                    expenseDescription = state.expense.expenseDescription,
                    timestamp = state.expense.timestamp,
                    expenseDetails = state.expenseDetails
                ] send in
                    if case let .loaded(expenseDetails) = expenseDetails {
                        await send(.setExpenseDetails(.refreshing(expenseDetails)))
                    } else {
                        await send(.setExpenseDetails(.loading))
                    }

                    let expenseDetails = try await self.service.getExpenses(
                        id: id,
                        expenseDescription: expenseDescription,
                        timestamp: timestamp
                    )

                    await send(.setExpenseDetails(.loaded(expenseDetails)))
                } catch: { error, send in
                    await send(.setExpenseDetails(.error(error as? MessageResponse ?? error)))
                }

            case let .setExpenseDetails(expenseDetails):
                state.expenseDetails = expenseDetails

                return .none
            }
        }
    }
}
