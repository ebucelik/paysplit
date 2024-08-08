//
//  OverviewCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import ComposableArchitecture

@Reducer
struct OverviewCore {
    @ObservableState
    struct State: Equatable {
        enum OverviewSelection: String {
            case people = "People"
            case open = "Open"
            case paid = "Paid"
        }

        var selection: OverviewSelection = .people

        var people = PeopleCore.State()
        var openPayment = OpenPaymentCore.State()
        var paidPayment = PaidPaymentCore.State()
    }

    @CasePathable
    enum Action: BindableAction {
        case people(PeopleCore.Action)
        case openPayment(OpenPaymentCore.Action)
        case paidPayment(PaidPaymentCore.Action)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<OverviewCore> {
        BindingReducer()

        Scope(
            state: \.people,
            action: \.people
        ) {
            PeopleCore()
        }

        Scope(
            state: \.openPayment,
            action: \.openPayment
        ) {
            OpenPaymentCore()
        }

        Scope(
            state: \.paidPayment,
            action: \.paidPayment
        ) {
            PaidPaymentCore()
        }

        Reduce { state, action in
            switch action {
            case .people:
                return .none

            case .openPayment:
                return .none

            case .paidPayment:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
