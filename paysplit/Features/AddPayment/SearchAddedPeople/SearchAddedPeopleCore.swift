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
        var searchTerm: String = ""
    }

    @CasePathable
    enum Action: BindableAction {
        case searchAddedPeople(String)
        case setSearchAddedPeople(ViewState<[Account]>)

        case binding(BindingAction<State>)
    }

    @Dependency(\.addPeopleService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .searchAddedPeople(searchTerm):
                guard let account = state.account else { return .none }

                struct DebounceId: Hashable {}

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
                }
                .debounce(id: DebounceId(), for: 1, scheduler: DispatchQueue.main)

            case let .setSearchAddedPeople(searchAddedPeople):
                state.searchAddedPeople = searchAddedPeople

                return .none

            case .binding:
                guard state.searchTerm.count > 2 else { return .send(.setSearchAddedPeople(.none)) }

                return .send(.searchAddedPeople(state.searchTerm))
            }
        }
    }
}
