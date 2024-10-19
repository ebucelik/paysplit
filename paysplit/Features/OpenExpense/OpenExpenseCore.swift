//
//  OpenExpenseCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct OpenExpenseCore {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        var openExpenses: ViewState<[OpenExpense]> = .none
        var allOpenExpenses: [OpenExpense] = []

        enum SortingKeys: String, CaseIterable, Hashable {
            case newest = "Newest"
            case oldest = "Oldest"
            case mostExpensive = "Most Expensive"
            case leastExpensive = "Least Expensive"
        }

        enum FilterKeys: String, CaseIterable, Hashable {
            case all = "All"
            case youOwe = "You Owe"
            case youGet = "You Get"
        }

        var sorting: SortingKeys = .newest
        var filter: FilterKeys = .all
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case loadOpenExpenses
        case setOpenExpenses(ViewState<[OpenExpense]>)
        case setAllOpenExpenses([OpenExpense])
        case sortingChanged
        case filterChanged
        case binding(BindingAction<State>)
    }

    @Dependency(\.openExpenseService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .send(.loadOpenExpenses)

            case .loadOpenExpenses:
                guard let account = state.account else { return .none }

                return .run { [id = account.id, openExpensesState = state.openExpenses] send in
                    if case let .loaded(openExpenses) = openExpensesState {
                        await send(.setOpenExpenses(.refreshing(openExpenses)))
                    } else {
                        await send(.setOpenExpenses(.loading))
                    }

                    let openExpenses = try await self.service.openExpenses(debtorId: id)

                    await send(.setAllOpenExpenses(openExpenses))
                    await send(.setOpenExpenses(.loaded(openExpenses.sorted { $0.timestamp > $1.timestamp })))
                } catch: { error, send in
                    await send(.setOpenExpenses(.error(error as? MessageResponse ?? error)))
                }

            case let .setOpenExpenses(openExpenses):
                state.openExpenses = openExpenses

                return .none

            case let .setAllOpenExpenses(openExpenses):
                state.allOpenExpenses = openExpenses
                state.filter = .all
                state.sorting = .newest

                return .none

            case .sortingChanged:
                guard case let .loaded(openExpenses) = state.openExpenses else { return .none }

                let sortedOpenExpenses: [OpenExpense]

                switch state.sorting {
                case .newest:
                    sortedOpenExpenses = openExpenses.sorted { $0.timestamp > $1.timestamp }
                case .oldest:
                    sortedOpenExpenses = openExpenses.sorted { $0.timestamp < $1.timestamp }
                case .mostExpensive:
                    let numberFormatter = NumberFormatter()
                    numberFormatter.decimalSeparator = ","

                    sortedOpenExpenses = openExpenses.sorted {
                        (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) >
                        (numberFormatter.number(from: $1.expenseAmount)?.doubleValue ?? 0)
                    }
                case .leastExpensive:
                    let numberFormatter = NumberFormatter()
                    numberFormatter.decimalSeparator = ","

                    sortedOpenExpenses = openExpenses.sorted {
                        (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) <
                            (numberFormatter.number(from: $1.expenseAmount)?.doubleValue ?? 0)
                    }
                }

                return .send(.setOpenExpenses(.loaded(sortedOpenExpenses)))

            case .filterChanged:
                let openExpenses = state.allOpenExpenses
                let filteredOpenExpenses: [OpenExpense]

                switch state.filter {
                case .all:
                    filteredOpenExpenses = state.allOpenExpenses
                case .youOwe:
                    filteredOpenExpenses = openExpenses.filter { $0.creatorId != state.account?.id }
                case .youGet:
                    filteredOpenExpenses = openExpenses.filter { $0.debtorId != state.account?.id }
                }

                return .concatenate(
                    [
                        .send(.setOpenExpenses(.loaded(filteredOpenExpenses))),
                        .send(.sortingChanged)
                    ]
                )

            case .binding:
                return .none
            }
        }
    }
}
