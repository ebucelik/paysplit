//
//  SearchAddedPeopleCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 12.10.24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchAddedPeopleCore {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        var searchAddedPeople: ViewState<[Account]> = .none
        var addedPeopleToSplitAmount: [Account] = []
        var searchTerm: String = ""
    }

    @CasePathable
    enum Action: BindableAction {
        case searchAddedPeople(String)
        case setSearchAddedPeople(ViewState<[Account]>)

        case addOrRemovePerson(Account)

        case binding(BindingAction<State>)

        enum Delegate {
            case evaluateNextStep
        }

        case delegate(Delegate)
    }

    @Dependency(\.addPeopleService) var service

    enum CancelID {
        case search
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .searchAddedPeople(searchTerm):
                guard let account = state.account else { return .none }

                var trimmedSearchTerm = searchTerm

                while trimmedSearchTerm.last?.isWhitespace == true {
                    trimmedSearchTerm = String(trimmedSearchTerm.dropLast())
                }

                return .run { [
                    searchAddedPeople = state.searchAddedPeople,
                    id = account.id,
                    term = trimmedSearchTerm
                ] send in
                    if case let .loaded(searchAddedPeople) = searchAddedPeople {
                        await send(.setSearchAddedPeople(.refreshing(searchAddedPeople)))
                    } else {
                        await send(.setSearchAddedPeople(.loading))
                    }

                    let searchAddedPeople = try await self.service.searchAddedPeople(id: id, term: term)

                    await send(.setSearchAddedPeople(.loaded(searchAddedPeople)))
                } catch: { error, send in
                    await send(.setSearchAddedPeople(.error(error as? MessageResponse ?? error)))
                }.debounce(id: CancelID.search, for: 1, scheduler: DispatchQueue.main)

            case let .setSearchAddedPeople(searchAddedPeople):
                state.searchAddedPeople = searchAddedPeople

                return .none

            case let .addOrRemovePerson(account):
                if let personIndex = state.addedPeopleToSplitAmount.firstIndex(where: { $0.id == account.id }) {
                    state.addedPeopleToSplitAmount.remove(at: personIndex)
                } else {
                    state.addedPeopleToSplitAmount.append(account)
                }

                return .none

            case .binding:
                guard state.searchTerm.count > 2 else { return .send(.setSearchAddedPeople(.none)) }

                return .send(.searchAddedPeople(state.searchTerm))

            case .delegate:
                return .none
            }
        }
    }
}
