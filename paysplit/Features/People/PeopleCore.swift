//
//  PeopleCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer 
struct PeopleCore {
    @ObservableState
    struct State: Equatable {
        var people: ViewState<[Account]> = .none
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case loadAddedPeople
        case setPeopleState(ViewState<[Account]>)
    }

    var body: some ReducerOf<PeopleCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.people == .none else { return .none }

                return .send(.loadAddedPeople)

            case .loadAddedPeople:
                return .run { [peopleState = state.people] send in
                    if case let .loaded(people) = peopleState {
                        await send(.setPeopleState(.refreshing(people)))
                    } else {
                        await send(.setPeopleState(.loading))
                    }

                    try await Task.sleep(for: .seconds(1))

                    await send(.setPeopleState(.loaded(.mocks)))
                }

            case let .setPeopleState(peopleState):
                state.people = peopleState

                return .none
            }
        }
    }
}
