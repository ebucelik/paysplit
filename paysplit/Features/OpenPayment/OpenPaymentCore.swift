//
//  OpenPaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer
struct OpenPaymentCore {
    @ObservableState
    struct State: Equatable {
        var openPayments: ViewState<[OpenPaymentAccount]> = .none
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case loadOpenPayments
        case setOpenPayments(ViewState<[OpenPaymentAccount]>)
    }

    var body: some ReducerOf<OpenPaymentCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.openPayments == .none else { return .none }

                return .send(.loadOpenPayments)

            case .loadOpenPayments:
                return .run { [openPaymentsState = state.openPayments] send in
                    if case let .loaded(openPayments) = openPaymentsState {
                        await send(.setOpenPayments(.refreshing(openPayments)))
                    } else {
                        await send(.setOpenPayments(.loading))
                    }

                    try await Task.sleep(for: .seconds(1))

                    await send(.setOpenPayments(.loaded(.init())))
                }

            case let .setOpenPayments(openPayments):
                state.openPayments = openPayments

                return .none
            }
        }
    }
}
