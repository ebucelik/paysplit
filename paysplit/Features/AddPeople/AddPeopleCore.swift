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

        var searchTerm = ""
        var selectedIdToAdd: Int? = nil
        var selectedIdToRemove: Int? = nil

        @Presents
        var alert: AlertState<Action.Alert>?
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case loadAddedPeople
        case setPeopleState(ViewState<[Account]>)
        case loadSearchedPeople(String)
        case setSearchedPeople(ViewState<[Account]>)
        case addPerson(Int)
        case setSelectedIdToAdd(Int?)
        case setSelectedIdToRemove(Int?)

        case removeButtonTapped(id: Int, username: String)
        case blockButtonTapped(id: Int, username: String)
        case reportButtonTapped(id: Int, username: String)
        case alert(PresentationAction<Alert>)

        @CasePathable
        enum Alert: Equatable {
            case removePerson(Int)
            case blockAccount(Int)
            case reportAccount
        }

        case binding(BindingAction<State>)
    }

    @Dependency(\.addPeopleService) var service

    var body: some ReducerOf<AddPeopleCore> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.people == .none else { return .none }

                return .send(.loadAddedPeople)

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

            case let .addPerson(id):
                guard let account = state.account else { return .none }

                return .run { [term = state.searchTerm] send in
                    await send(.setSelectedIdToAdd(id))

                    _ = try await self.service.addPerson(firstId: account.id, secondId: id)

                    OneSignalClient.shared.sendPush(
                        with: String(localized: " has added you as a friend."),
                        username: "\(account.username)",
                        title: String(localized: "New Message"),
                        id: id
                    )

                    await send(.loadAddedPeople)
                    await send(.loadSearchedPeople(term))
                    await send(.setSelectedIdToAdd(nil))
                } catch: { _, send in
                    await send(.setSelectedIdToAdd(nil))
                }

            case let .setSelectedIdToAdd(id):
                state.selectedIdToAdd = id

                return .none

            case let .setSelectedIdToRemove(id):
                state.selectedIdToRemove = id

                return .none

            case let .removeButtonTapped(id, username):
                state.alert = AlertState(
                    title: {
                        TextState("Attention")
                    },
                    actions: {
                        ButtonState(
                            role: .cancel,
                            label: {
                                TextState("Cancel")
                            }
                        )
                        ButtonState(
                            role: .destructive,
                            action: .removePerson(id),
                            label: {
                                TextState("Remove")
                            }
                        )
                    },
                    message: {
                        TextState("Do you want to remove \(username) from your list?")
                    }
                )

                return .none

            case let .blockButtonTapped(id, username):
                state.alert = AlertState(
                    title: {
                        TextState("Attention")
                    },
                    actions: {
                        ButtonState(
                            role: .cancel,
                            label: {
                                TextState("Cancel")
                            }
                        )
                        ButtonState(
                            role: .destructive,
                            action: .blockAccount(id),
                            label: {
                                TextState("Block")
                            }
                        )
                    },
                    message: {
                        TextState("Do you want to block \(username)?")
                    }
                )

                return .none

            case let .reportButtonTapped(_, username):
                state.alert = AlertState(
                    title: {
                        TextState("Attention")
                    },
                    actions: {
                        ButtonState(
                            role: .cancel,
                            label: {
                                TextState("Cancel")
                            }
                        )
                        ButtonState(
                            role: .destructive,
                            action: .reportAccount,
                            label: {
                                TextState("Report")
                            }
                        )
                    },
                    message: {
                        TextState("Do you want to report \(username) for spam, abuse or any other harmful content?")
                    }
                )

                return .none

            case let .alert(.presented(.removePerson(id))):
                guard let account = state.account else { return .none }

                return .run { send in
                    await send(.setSelectedIdToRemove(id))

                    _ = try await self.service.removePerson(firstId: account.id, secondId: id)

                    await send(.loadAddedPeople)
                    await send(.setSelectedIdToRemove(nil))
                } catch: { _, send in
                    await send(.setSelectedIdToRemove(nil))
                }

            case let .alert(.presented(.blockAccount(id))):
                guard let account = state.account else { return .none }

                return .run { send in
                    await send(.setSelectedIdToRemove(id))

                    _ = try await self.service.removePerson(firstId: account.id, secondId: id)

                    await send(.loadAddedPeople)
                    await send(.setSelectedIdToRemove(nil))
                } catch: { _, send in
                    await send(.setSelectedIdToRemove(nil))
                }

            case .alert(.presented(.reportAccount)):
                return .none

            case .alert(.dismiss):
                return .none

            case .binding(\.searchTerm):
                guard state.searchTerm.count > 2 else { return .send(.setSearchedPeople(.none)) }

                return .send(.loadSearchedPeople(state.searchTerm))

            case .binding:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
