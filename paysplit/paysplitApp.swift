//
//  paysplitApp.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 02.08.24.
//

import SwiftUI
import StripePaymentSheet
import ComposableArchitecture

@main
struct paysplitApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
//            PaymentButtonView(
//                store: Store(
//                    initialState: PaymentCore.State(),
//                    reducer: {
//                        PaymentCore(service: Services.paymentSheetService)
//                    }
//                )
//            )
//            .onOpenURL { url in
//                let stripeHandled = StripeAPI.handleURLCallback(with: url)
//            }
        }
    }
}
