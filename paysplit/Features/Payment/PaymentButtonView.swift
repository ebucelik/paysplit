//
//  PaymentButtonView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import SwiftUI
import StripePaymentSheet
import ComposableArchitecture

struct PaymentButtonView: View {
    let store: StoreOf<PaymentCore>
    @State
    var paymentSheet: PaymentSheet?

    var body: some View {
        VStack(spacing: 16) {
            Button {
                store.send(.loadPaymentSheet)
            } label: {
                Text("Load payment sheet.")
            }

            switch store.paymentSheet {
            case .loading, .refreshing:
                ProgressView().progressViewStyle(.circular)

            case let .loaded(paymentSheetResponse):
                if let paymentSheet = paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: { paymentCompletion in
                            switch paymentCompletion {
                            case .completed:
                                print("Payment completed")
                            case .canceled:
                                print("Payment canceled")
                            case .failed(error: let error):
                                print("Payment error: \(error.localizedDescription)")
                            }
                        }
                    ) {
                        Text("Pay back.")
                    }
                }

            case .none:
                Text("Not loaded yet.")

            case let .error(error):
                Text(error.asErrorResponse?.message ?? "Error has occured.")
            }
        }
        .padding()
        .onChange(of: store.paymentSheet) {
            if case let .loaded(paymentSheetResponse) = store.paymentSheet {
                STPAPIClient.shared.publishableKey = paymentSheetResponse.publishableKey

                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Paysplit"
                configuration.applePay = PaymentSheet.ApplePayConfiguration(
                    merchantId: "merchant.com.ebucelik.paysplit",
                    merchantCountryCode: "AT"
                )

                paymentSheet = PaymentSheet(
                    paymentIntentClientSecret: paymentSheetResponse.clientSecret,
                    configuration: configuration
                )
            }
        }
    }
}
