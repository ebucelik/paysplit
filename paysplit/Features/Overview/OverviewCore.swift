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

        var addPeople: AddPeopleCore.State
        var openPayment = OpenPaymentCore.State()
        var paidPayment = PaidPaymentCore.State()

        var account: Account?

        init(
            selection: OverviewSelection = .open,
            account: Account? = nil
        ) {
            self.selection = selection
            self.addPeople = AddPeopleCore.State(account: account)
            self.account = account
        }
    }

    @CasePathable
    enum Action: BindableAction {
        case addPeople(AddPeopleCore.Action)
        case openPayment(OpenPaymentCore.Action)
        case paidPayment(PaidPaymentCore.Action)
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<OverviewCore> {
        BindingReducer()

        Scope(
            state: \.addPeople,
            action: \.addPeople
        ) {
            AddPeopleCore()
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
            case .addPeople:
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
