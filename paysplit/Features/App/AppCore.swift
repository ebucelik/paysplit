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

        @Presents
        var addPaymentCoreState: AddPaymentCore.State?
    }

    @CasePathable
    enum Action: BindableAction {
        case onViewAppear

        case showAddPaymentView
        case addPayment(PresentationAction<AddPaymentCore.Action>)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<AppCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none

            case .showAddPaymentView:
                state.addPaymentCoreState = AddPaymentCore.State()
                
                return .none

            case .addPayment:
                return .none

            case .binding:
                return .none
            }
        }
        .ifLet(\.$addPaymentCoreState, action: \.addPayment) {
            AddPaymentCore()
        }
    }
}
