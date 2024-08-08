//
//  AppCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import ComposableArchitecture

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
        var account = AccountCore.State()

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

        case showAddPaymentView
        case overview(OverviewCore.Action)
        case addPayment(PresentationAction<AddPaymentCore.Action>)
        case account(AccountCore.Action)
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
            state: \.account,
            action: \.account
        ) {
            AccountCore()
        }

        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none

            case .showAddPaymentView:
                state.addPayment = AddPaymentCore.State()
                
                return .none

            case .overview:
                return .none

            case .addPayment:
                return .none

            case .account:
                return .none

            case .binding:
                return .none
            }
        }
        .ifLet(\.$addPayment, action: \.addPayment) {
            AddPaymentCore()
        }
    }
}
