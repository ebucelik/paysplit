//
//  PaymentCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import ComposableArchitecture
import StripePaymentSheet

@Reducer
struct PaymentCore {
    @ObservableState
    struct State: Equatable {
        var paymentSheet: ViewState<PaymentSheetResponse> = .none
    }

    @CasePathable
    enum Action {
        case loadPaymentSheet
        case setPaymentSheet(ViewState<PaymentSheetResponse>)
    }

    let service: PaymentSheetServiceProtocol

    var body: some ReducerOf<PaymentCore> {
        Reduce { state, action in
            switch action {
            case .loadPaymentSheet:
                return .run { send in
                    await send(.setPaymentSheet(.loading))

                    let paymentSheetResponse = try await self.service.createPaymentSheet()

                    await send(.setPaymentSheet(.loaded(paymentSheetResponse)))
                } catch: { error, send in
                    await send(.setPaymentSheet(.error(error as? ErrorResponse ?? error)))
                }

            case let .setPaymentSheet(paymentSheet):
                state.paymentSheet = paymentSheet

                return .none
            }
        }
    }
}
