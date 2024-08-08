//
//  PaidPaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture

@Reducer
struct PaidPaymentCore {
    @ObservableState
    struct State: Equatable {
        var paidPayments: ViewState<[PaidPaymentAccount]> = .none
    }

    enum Action {
        case onViewAppear
        case loadPaidPayments
        case setPaidPayments(ViewState<[PaidPaymentAccount]>)
    }

    var body: some ReducerOf<PaidPaymentCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                guard state.paidPayments == .none else { return .none }

                return .send(.loadPaidPayments)

            case .loadPaidPayments:
                return .run { [paidPaymentsState = state.paidPayments] send in
                    if case let .loaded(paidPayments) = paidPaymentsState {
                        await send(.setPaidPayments(.refreshing(paidPayments)))
                    } else {
                        await send(.setPaidPayments(.loading))
                    }

                    try await Task.sleep(for: .seconds(1))

                    await send(.setPaidPayments(.loaded(.mocks)))
                }

            case let .setPaidPayments(paidPayments):
                state.paidPayments = paidPayments

                return .none
            }
        }
    }
}
