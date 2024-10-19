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
        var openExpense: OpenExpenseCore.State
        var paidExpense: PaidExpenseCore.State

        var account: Account?

        init(
            selection: OverviewSelection = .open,
            account: Account? = nil
        ) {
            self.selection = selection
            self.addPeople = AddPeopleCore.State(account: account)
            self.openExpense = OpenExpenseCore.State(account: account)
            self.paidExpense = PaidExpenseCore.State(account: account)
            self.account = account
        }
    }

    @CasePathable
    enum Action: BindableAction {
        case addPeople(AddPeopleCore.Action)
        case openExpense(OpenExpenseCore.Action)
        case paidExpense(PaidExpenseCore.Action)
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
            state: \.openExpense,
            action: \.openExpense
        ) {
            OpenExpenseCore()
        }

        Scope(
            state: \.paidExpense,
            action: \.paidExpense
        ) {
            PaidExpenseCore()
        }

        Reduce { state, action in
            switch action {
            case .addPeople:
                return .none

            case .openExpense:
                return .none

            case .paidExpense:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
