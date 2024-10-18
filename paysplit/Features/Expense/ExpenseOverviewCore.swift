//
//  PaymentsOverviewCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 17.10.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ExpenseOverviewCore {
    @ObservableState
    struct State {
        var account: Account?

        var addExpense: AddExpenseCore.State

        var isAddExpenseShown = false

        var groupedExpenses: ViewState<[Expense]> = .none

        enum SortingKeys: String, CaseIterable, Hashable {
            case newest = "Newest"
            case oldest = "Oldest"
            case mostExpensive = "Most Expensive"
            case leastExpensive = "Least Expensive"
        }

        var sorting: SortingKeys = .newest

        @Presents
        var expenseDetail: ExpenseDetailCore.State?

        init(account: Account? = nil) {
            self.account = account
            self.addExpense = AddExpenseCore.State(account: account)
        }
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case loadGroupedExpenses
        case setGroupedExpenses(ViewState<[Expense]>)
        case sortingChanged
        case showExpenseDetail(Expense)
        case expenseDetail(PresentationAction<ExpenseDetailCore.Action>)
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
                guard case .none = state.groupedExpenses else { return .none }

                return .send(.loadGroupedExpenses)

            case .loadGroupedExpenses:
                guard let account = state.account else { return .none }

                return .run { [id = account.id, groupedExpenses = state.groupedExpenses] send in
                    if case let .loaded(groupedExpenses) = groupedExpenses {
                        await send(.setGroupedExpenses(.refreshing(groupedExpenses)))
                    } else {
                        await send(.setGroupedExpenses(.loading))
                    }

                    let groupedExpenses = try await self.service.getGroupedExpenses(id: id)

                    await send(.setGroupedExpenses(.loaded(groupedExpenses.sorted { $0.timestamp > $1.timestamp })))
                } catch: { error, send in
                    await send(.setGroupedExpenses(.error(error as? MessageResponse ?? error)))
                }

            case let .setGroupedExpenses(groupedExpenses):
                state.groupedExpenses = groupedExpenses

                return .none

            case .sortingChanged:
                guard case let .loaded(groupedExpenses) = state.groupedExpenses else { return .none }

                let sortedGroupedExpenses: [Expense]

                switch state.sorting {
                case .newest:
                    sortedGroupedExpenses = groupedExpenses.sorted { $0.timestamp > $1.timestamp }
                case .oldest:
                    sortedGroupedExpenses = groupedExpenses.sorted { $0.timestamp < $1.timestamp }
                case .mostExpensive:
                    let numberFormatter = NumberFormatter()
                    numberFormatter.decimalSeparator = ","

                    sortedGroupedExpenses = groupedExpenses.sorted {
                        (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) >
                        (numberFormatter.number(from: $1.expenseAmount)?.doubleValue ?? 0)
                    }
                case .leastExpensive:
                    let numberFormatter = NumberFormatter()
                    numberFormatter.decimalSeparator = ","

                    sortedGroupedExpenses = groupedExpenses.sorted {
                        (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) <
                            (numberFormatter.number(from: $1.expenseAmount)?.doubleValue ?? 0)
                    }
                }

                return .send(.setGroupedExpenses(.loaded(sortedGroupedExpenses)))

            case let .showExpenseDetail(expense):
                state.expenseDetail = ExpenseDetailCore.State(
                    account: state.account,
                    expense: expense
                )
                
                return .none

            case .expenseDetail(.presented):
                return .none

            case .expenseDetail(.dismiss):
                state.expenseDetail = nil

                return .none

            case .showAddExpense:
                state.isAddExpenseShown = true

                return .none

            case let .addExpense(action):
                switch action {
                case .delegate(.didCreatedExpense):
                    return .send(.loadGroupedExpenses)

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
        .ifLet(\.$expenseDetail, action: \.expenseDetail) {
            ExpenseDetailCore()
        }
    }
}
