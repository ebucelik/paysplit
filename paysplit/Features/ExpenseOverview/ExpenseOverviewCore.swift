//
//  PaymentsOverviewCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 17.10.24.
//

import ComposableArchitecture

@Reducer
struct ExpenseOverviewCore {
    @ObservableState
    struct State {
        var account: Account?

        var addExpense: AddExpenseCore.State

        var isAddExpenseShown = false

        var expenses: ViewState<[Expense]> = .none

        init(
            account: Account? = nil
        ) {
            self.account = account
            self.addExpense = AddExpenseCore.State(account: account)
        }
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case loadExpenses
        case setExpenses(ViewState<[Expense]>)
        case showAddExpense
        case addExpense(AddExpenseCore.Action)
        case binding(BindingAction<State>)
    }

    @Dependency(\.expenseOverviewService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.addExpense, action: \.addExpense) {
            AddExpenseCore()
        }

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard case .none = state.expenses else { return .none }

                return .send(.loadExpenses)

            case .loadExpenses:
                guard let account = state.account else { return .none }

                return .run { [id = account.id, expenses = state.expenses] send in
                    if case let .loaded(expenses) = expenses {
                        await send(.setExpenses(.refreshing(expenses)))
                    } else {
                        await send(.setExpenses(.loading))
                    }

                    let expenses = try await self.service.getExpenses(id: id)

                    await send(.setExpenses(.loaded(expenses)))
                } catch: { error, send in
                    await send(.setExpenses(.error(error as? MessageResponse ?? error)))
                }

            case let .setExpenses(expenses):
                state.expenses = expenses

                return .none

            case .showAddExpense:
                state.isAddExpenseShown = true

                return .none

            case let .addExpense(action):
                switch action {
                case .delegate(.didCreatedExpense):
                    return .send(.loadExpenses)
                    
                case .delegate(.dismiss):
                    state.isAddExpenseShown = false

                default:
                    break
                }

                return .none

            case .binding:
                return .none
            }
        }
    }
}
