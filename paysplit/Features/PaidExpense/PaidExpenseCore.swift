//
//  PaidExpenseCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct PaidExpenseCore {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        var paidExpenses: ViewState<[OpenPaidExpense]> = .none
        var allPaidExpenses: [OpenPaidExpense] = []

        enum SortingKeys: String, CaseIterable, Hashable {
            case newest = "Newest"
            case oldest = "Oldest"
            case mostExpensive = "Most Expensive"
            case leastExpensive = "Least Expensive"
        }

        enum FilterKeys: String, CaseIterable, Hashable {
            case all = "All"
            case youPaid = "You Paid"
            case youGot = "You Got"
        }

        var sorting: SortingKeys = .newest
        var filter: FilterKeys = .all
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case loadPaidExpenses
        case setPaidExpenses(ViewState<[OpenPaidExpense]>)
        case setAllPaidExpenses([OpenPaidExpense])
        case sortingChanged
        case filterChanged
        case binding(BindingAction<State>)
    }

    @Dependency(\.paidExpenseService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .send(.loadPaidExpenses)

            case .loadPaidExpenses:
                guard let account = state.account else { return .none }

                return .run { [id = account.id, paidExpensesState = state.paidExpenses] send in
                    if case let .loaded(paidExpenses) = paidExpensesState {
                        await send(.setPaidExpenses(.refreshing(paidExpenses)))
                    } else {
                        await send(.setPaidExpenses(.loading))
                    }

                    let paidExpenses = try await self.service.paidExpenses(id: id)

                    await send(.setAllPaidExpenses(paidExpenses))
                    await send(.setPaidExpenses(.loaded(paidExpenses.sorted { $0.timestamp > $1.timestamp })))
                } catch: { error, send in
                    await send(.setPaidExpenses(.error(error as? MessageResponse ?? error)))
                }

            case let .setPaidExpenses(paidExpenses):
                state.paidExpenses = paidExpenses

                return .none

            case let .setAllPaidExpenses(paidExpenses):
                state.allPaidExpenses = paidExpenses
                state.filter = .all
                state.sorting = .newest

                return .none

            case .sortingChanged:
                guard case let .loaded(paidExpenses) = state.paidExpenses else { return .none }

                let sortedPaidExpenses: [OpenPaidExpense]

                switch state.sorting {
                case .newest:
                    sortedPaidExpenses = paidExpenses.sorted { $0.timestamp > $1.timestamp }
                case .oldest:
                    sortedPaidExpenses = paidExpenses.sorted { $0.timestamp < $1.timestamp }
                case .mostExpensive:
                    let numberFormatter = NumberFormatter()
                    numberFormatter.decimalSeparator = ","

                    sortedPaidExpenses = paidExpenses.sorted {
                        (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) >
                        (numberFormatter.number(from: $1.expenseAmount)?.doubleValue ?? 0)
                    }
                case .leastExpensive:
                    let numberFormatter = NumberFormatter()
                    numberFormatter.decimalSeparator = ","

                    sortedPaidExpenses = paidExpenses.sorted {
                        (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) <
                            (numberFormatter.number(from: $1.expenseAmount)?.doubleValue ?? 0)
                    }
                }

                return .send(.setPaidExpenses(.loaded(sortedPaidExpenses)))

            case .filterChanged:
                let paidExpenses = state.allPaidExpenses
                let filteredPaidExpenses: [OpenPaidExpense]

                switch state.filter {
                case .all:
                    filteredPaidExpenses = state.allPaidExpenses
                case .youPaid:
                    filteredPaidExpenses = paidExpenses.filter { $0.creatorId != state.account?.id }
                case .youGot:
                    filteredPaidExpenses = paidExpenses.filter { $0.debtorId != state.account?.id }
                }

                return .concatenate(
                    [
                        .send(.setPaidExpenses(.loaded(filteredPaidExpenses))),
                        .send(.sortingChanged)
                    ]
                )

            case .binding:
                return .none
            }
        }
    }
}
