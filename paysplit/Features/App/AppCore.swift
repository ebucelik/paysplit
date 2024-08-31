//
//  AppCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppCore {
    @ObservableState
    struct State: Equatable {
        var showOverview = false
        var selectedTab = 0
        var previousSelectedTab = 0

        var overview = OverviewCore.State()
        @Presents
        var addPayment: AddPaymentCore.State?
        var accountState: AccountCore.State = AccountCore.State(accountState: .none)
        @Presents
        var entry: EntryCore.State?

        var account: Account? = nil

        mutating func setSelectedTab() {
            selectedTab = previousSelectedTab
        }

        mutating func setPreviousSelectedTab() {
            previousSelectedTab = selectedTab
        }
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case checkAccount
        case showEntry

        case showAddPaymentView
        case overview(OverviewCore.Action)
        case addPayment(PresentationAction<AddPaymentCore.Action>)
        case account(AccountCore.Action)
        case entry(PresentationAction<EntryCore.Action>)

        case binding(BindingAction<State>)
    }

    let entryService: EntryServiceProtocol

    var body: some ReducerOf<AppCore> {
        BindingReducer()

        Scope(
            state: \.overview,
            action: \.overview
        ) {
            OverviewCore()
        }

        Scope(
            state: \.accountState,
            action: \.account
        ) {
            AccountCore()
        }

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                struct DebounceId: Hashable {}

                if state.account == nil {
                    return .send(.checkAccount)
                        .debounce(id: DebounceId(), for: 0.5, scheduler: DispatchQueue.main)
                }

                return .none

            case .checkAccount:
                if let accountData = UserDefaults.standard.data(forKey: "account") {
                    do {
                        let account = try JSONDecoder().decode(Account.self, from: accountData)

                        state.accountState = AccountCore.State(accountState: .loaded(account))
                        state.account = account
                        state.entry = nil

                        return .send(.entry(.dismiss))
                    } catch {
                        return .send(.showEntry)
                    }
                }

                return .send(.showEntry)

            case .showEntry:
                state.entry = EntryCore.State()

                return .none

            case .showAddPaymentView:
                state.addPayment = AddPaymentCore.State()
                
                return .none

            case .overview:
                return .none

            case let .addPayment(.presented(action)):
                switch action {
                case .delegate(.dismiss):
                    return .send(.addPayment(.dismiss))
                default:
                    return .none
                }

            case .addPayment(.dismiss):
                state.addPayment = nil

                return .none

            case .account:
                return .none

            case .entry(.presented(.delegate(.showOverview))):
                return .send(.checkAccount)

            case .entry:
                return .none

            case .binding:
                return .none
            }
        }
        .ifLet(\.$addPayment, action: \.addPayment) {
            AddPaymentCore()
        }
        .ifLet(\.$entry, action: \.entry) {
            EntryCore(service: entryService)
        }
    }
}
