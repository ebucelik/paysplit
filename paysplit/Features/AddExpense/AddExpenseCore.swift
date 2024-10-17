//
//  AddExpenseCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddExpenseCore {
    @ObservableState
    struct State {
        var account: Account?
        
        var addExpenseStep: AddExpenseStep? = .searchPeople

        var selectedPeople: IdentifiedArrayOf<Account> = IdentifiedArray()
        var searchedPeople: ViewState<[Account]> = .none

        var searchAddedPeople: SearchAddedPeopleCore.State

        var path = StackState<Path.State>()

        var expenseDescription: String = ""
        var expenseAmount: String = ""

        init(
            account: Account? = nil,
            addExpenseStep: AddExpenseStep? = nil,
            searchAddedPeople: SearchAddedPeopleCore.State? = nil,
            path: StackState<Path.State> = StackState<Path.State>()
        ) {
            self.account = account
            self.addExpenseStep = addExpenseStep
            self.searchAddedPeople = SearchAddedPeopleCore.State(account: account)
            self.path = path
        }
    }

    @Reducer
    enum Path {
        case fullAmount(FullAmountCore)
        case splitAmount(SplitAmountCore)
    }

    @CasePathable
    enum Action: BindableAction {
        enum Delegate {
            case didCreatedExpense
            case dismiss
        }

        case onViewAppear
        case setSelectedPerson(Account)

        case evaluateNextStep
        case setCurrentStep(AddExpenseStep)

        case loadSearchedPeople(String)
        case setSearchedPeople(ViewState<[Account]>)

        case delegate(Delegate)
        case binding(BindingAction<State>)

        case searchAddedPeople(SearchAddedPeopleCore.Action)
        case path(StackActionOf<Path>)
    }

    @Dependency(\.addPeopleService) var addPeopleService

    var body: some ReducerOf<AddExpenseCore> {
        BindingReducer()

        Scope(state: \.searchAddedPeople, action: \.searchAddedPeople) {
            SearchAddedPeopleCore()
        }

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
                state.addExpenseStep = state.addExpenseStep?.nextStep()

                if state.addExpenseStep == nil || state.addExpenseStep == .sendPushNotification {
                    return .concatenate(
                        .send(.delegate(.didCreatedExpense)),
                        .send(.delegate(.dismiss))
                    )
                }

                switch state.addExpenseStep {
                case .fullAmount:
                    state.path.append(.fullAmount(FullAmountCore.State()))

                case .splitAmount:
                    state.path.append(
                        .splitAmount(
                            SplitAmountCore.State(
                                account: state.account,
                                expenseDescription: state.expenseDescription,
                                expenseAmount: state.expenseAmount,
                                addedPeople: state.searchAddedPeople.addedPeopleToSplitAmount
                            )
                        )
                    )

                default:
                    break
                }

                return .none

            case let .setCurrentStep(step):
                state.addExpenseStep = step

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

            case .delegate:
                return .none

            case .binding:
                return .none

            case let .searchAddedPeople(action):
                switch action {
                case .delegate(.evaluateNextStep):
                    return .send(.evaluateNextStep)

                default:
                    return .none
                }

            case let .path(stackAction):
                switch stackAction {
                case .element(id: _, action: let action):
                    switch action {
                    case let .fullAmount(
                        .delegate(
                            .evaluateNextStep(
                                expenseDescription,
                                expenseAmount
                            )
                        )
                    ):
                        state.expenseDescription = expenseDescription
                        state.expenseAmount = expenseAmount

                        return .send(.evaluateNextStep)

                    case .splitAmount(.delegate(.evaluateNextStep)):
                        return .send(.evaluateNextStep)

                    default:
                        break
                    }

                default:
                    break
                }

                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
