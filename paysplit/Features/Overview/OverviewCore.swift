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
            case open = "Open"
            case paid = "Paid"
        }

        var selection: OverviewSelection = .open

        @Presents
        var addPeople: AddPeopleCore.State?
        var openPayment = OpenPaymentCore.State()
        var paidPayment = PaidPaymentCore.State()
    }

    @CasePathable
    enum Action: BindableAction {
        case showAddPeopleView
        case addPeople(PresentationAction<AddPeopleCore.Action>)
        case openPayment(OpenPaymentCore.Action)
        case paidPayment(PaidPaymentCore.Action)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<OverviewCore> {
        BindingReducer()

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
            case .showAddPeopleView:
                state.addPeople = AddPeopleCore.State()
                return .none

            case .addPeople(.presented):
                return .none

            case .addPeople(.dismiss):
                state.addPeople = nil

                return .none

            case .openPayment:
                return .none

            case .paidPayment:
                return .none

            case .binding:
                return .none
            }
        }
        .ifLet(\.$addPeople, action: \.addPeople) {
            AddPeopleCore()
        }
    }
}
