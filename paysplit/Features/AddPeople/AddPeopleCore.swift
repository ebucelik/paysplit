//
//  AddPeopleCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer 
struct AddPeopleCore {
    @ObservableState
    struct State: Equatable {
        var account: Account?
        var people: ViewState<[Account]> = .none
        var searchedPeople: ViewState<[Account]> = .none

        var searchTerm: String = ""
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case loadSearchedPeople(String)
        case setSearchedPeople(ViewState<[Account]>)
        case loadAddedPeople
        case setPeopleState(ViewState<[Account]>)

        case binding(BindingAction<State>)
    }

    let service: AddPeopleServiceProtocol

    var body: some ReducerOf<AddPeopleCore> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.people == .none else { return .none }

                return .send(.loadAddedPeople)

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

                    let searchedPeople = try await self.service.searchPeople(id: id, term: term)

                    await send(.setSearchedPeople(.loaded(searchedPeople)))
                } catch: { error, send in
                    await send(.setSearchedPeople(.error(error as? MessageResponse ?? error)))
                }
                .debounce(id: DebounceId(), for: 1, scheduler: DispatchQueue.main)

            case let .setSearchedPeople(searchedPeopleState):
                state.searchedPeople = searchedPeopleState

                return .none

            case .loadAddedPeople:
                guard let account = state.account else { return .none }

                return .run { [
                    peopleState = state.people,
                    id = account.id
                ] send in
                    if case let .loaded(people) = peopleState {
                        await send(.setPeopleState(.refreshing(people)))
                    } else {
                        await send(.setPeopleState(.loading))
                    }

                    let people = try await self.service.getAddedPeople(id: id)

                    await send(.setPeopleState(.loaded(people)))
                } catch: { error, send in
                    await send(.setPeopleState(.error(error as? MessageResponse ?? error)))
                }

            case let .setPeopleState(peopleState):
                state.people = peopleState

                return .none

            case .binding(\.searchTerm):
                guard state.searchTerm.count > 2 else { return .send(.setSearchedPeople(.none)) }

                return .send(.loadSearchedPeople(state.searchTerm))

            case .binding:
                return .none
            }
        }
    }
}
