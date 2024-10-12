//
//  AddPaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddPaymentCore {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        
        var addPaymentStep: AddPaymentStep? = .searchPeople

        var selectedPeople: IdentifiedArrayOf<Account> = IdentifiedArray()
        var searchedPeople: ViewState<[Account]> = .none

        var expenseDescription = ""
        var expenseAmount = ""
    }

    @CasePathable
    enum Action: BindableAction {
        enum Delegate {
            case dismiss
        }

        case onViewAppear
        case setSelectedPerson(Account)

        case evaluateNextStep
        case setCurrentStep(AddPaymentStep)

        case loadSearchedPeople(String)
        case setSearchedPeople(ViewState<[Account]>)

        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    @Dependency(\.addPeopleService) var addPeopleService

    var body: some ReducerOf<AddPaymentCore> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .send(.setCurrentStep(.searchPeople))

            case let .setSelectedPerson(account):
                if state.selectedPeople.contains(account) {
                    if let index = state.selectedPeople.firstIndex(of: account) {
                        state.selectedPeople.remove(at: index)
                    }
                } else {
                    state.selectedPeople.append(account)
                }

                return .none

            case .evaluateNextStep:
                state.addPaymentStep = state.addPaymentStep?.nextStep()

                if state.addPaymentStep == nil {
                    return .send(.delegate(.dismiss))
                }

                return .none

            case let .setCurrentStep(step):
                state.addPaymentStep = step

                return .none

            case let .loadSearchedPeople(searchTerm):
                guard let account = state.account else { return .none }

                struct DebounceId: Hashable {}

                var trimmedSearchTerm = searchTerm

                while trimmedSearchTerm.last?.isWhitespace == true {
                    trimmedSearchTerm = String(trimmedSearchTerm.dropLast())
                }

                return .run { [
                    searchedPeople = state.searchedPeople,
                    id = account.id,
                    term = trimmedSearchTerm
                ] send in
                    if case let .loaded(searchedPeople) = searchedPeople {
                        await send(.setSearchedPeople(.refreshing(searchedPeople)))
                    } else {
                        await send(.setSearchedPeople(.loading))
                    }

                    let searchedPeople = try await self.addPeopleService.searchPeople(id: id, term: term)

                    await send(.setSearchedPeople(.loaded(searchedPeople)))
                } catch: { error, send in
                    await send(.setSearchedPeople(.error(error as? MessageResponse ?? error)))
                }
                .debounce(id: DebounceId(), for: 1, scheduler: DispatchQueue.main)

            case let .setSearchedPeople(searchedPeopleState):
                state.searchedPeople = searchedPeopleState

                return .none

            case .delegate(.dismiss):
                return .none

            case .binding:
                return .none
            }
        }
    }
}
