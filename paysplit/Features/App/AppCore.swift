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
    struct State {
        var showOverview = false

        var overview = OverviewCore.State()
        var expenseOverview = ExpenseOverviewCore.State()
        var accountState: AccountCore.State = AccountCore.State(accountState: .none)
        @Presents
        var entry: EntryCore.State?

        var account: Account? = nil
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear
        case checkAccount
        case showEntry
        case logout

        case overview(OverviewCore.Action)
        case expenseOverview(ExpenseOverviewCore.Action)
        case account(AccountCore.Action)
        case entry(PresentationAction<EntryCore.Action>)

        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<AppCore> {
        BindingReducer()

        Scope(
            state: \.overview,
            action: \.overview
        ) {
            OverviewCore()
        }

        Scope(
            state: \.expenseOverview,
            action: \.expenseOverview
        ) {
            ExpenseOverviewCore()
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

                        state.account = account
                        state.overview = OverviewCore.State(account: account)
                        state.expenseOverview = ExpenseOverviewCore.State(account: account)
                        state.accountState = AccountCore.State(accountState: .loaded(account))
                        state.entry = nil

                        NotificationCenter.default.post(name: .accountIsSet, object: nil)

                        return .none
                    } catch {
                        return .send(.showEntry)
                    }
                }

                return .send(.showEntry)

            case .showEntry:
                if state.entry == nil {
                    state.entry = EntryCore.State()
                }

                return .none

            case .logout:
                UserDefaults.standard.set(nil, forKey: "account")
                UserDefaults.standard.set(nil, forKey: "accessToken")
                UserDefaults.standard.set(nil, forKey: "refreshToken")

                return .send(.showEntry)

            case .overview:
                return .none

            case .expenseOverview:
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
        .ifLet(\.$entry, action: \.entry) {
            EntryCore()
        }
    }
}
