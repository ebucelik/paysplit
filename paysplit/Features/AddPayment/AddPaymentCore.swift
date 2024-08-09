//
//  AddPaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import ComposableArchitecture

@Reducer
struct AddPaymentCore {
    @ObservableState
    struct State: Equatable {
        var addedPeople: ViewState<[Account]> = .none
        var selectedPeople: IdentifiedArrayOf<Account> = IdentifiedArray()

        var expenseDescription = ""
        var expenseAmount = ""
    }

    @CasePathable
    enum Action: BindableAction {
        enum Delegate {
            case dismiss
        }

        case onViewAppear
        case loadAddedPeople
        case setPeopleState(ViewState<[Account]>)
        case setSelectedPerson(Account)
        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<AddPaymentCore> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.addedPeople == .none else { return .none }

                return .send(.loadAddedPeople)

            case .loadAddedPeople:
                return .run { [addedPeopleState = state.addedPeople] send in
                    if case let .loaded(addedPeople) = addedPeopleState {
                        await send(.setPeopleState(.refreshing(addedPeople)))
                    } else {
                        await send(.setPeopleState(.loading))
                    }

                    try await Task.sleep(for: .seconds(1))

                    await send(.setPeopleState(.loaded(.mocks)))
                }

            case let .setPeopleState(addedPeopleState):
                state.addedPeople = addedPeopleState

                return .none

            case let .setSelectedPerson(account):
                if state.selectedPeople.contains(account) {
                    if let index = state.selectedPeople.firstIndex(of: account) {
                        state.selectedPeople.remove(at: index)
                    }
                } else {
                    state.selectedPeople.append(account)
                }

                return .none

            case .delegate(.dismiss):
                return .none

            case .binding:
                return .none
            }
        }
    }
}
