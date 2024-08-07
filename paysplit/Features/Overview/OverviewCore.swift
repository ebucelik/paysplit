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
        var selection: OverviewSelection = .people

        enum OverviewSelection: String {
            case people = "People"
            case open = "Open"
            case paid = "Paid"
        }
    }

    @CasePathable
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<OverviewCore> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
