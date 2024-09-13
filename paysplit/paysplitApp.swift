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
            AppView(
                store: Store(
                    initialState: AppCore.State(),
                    reducer: {
                        AppCore(
                            entryService: Services.entryService,
                            accountService: Services.accountService,
                            addPeopleService: Services.addPeopleService
                        )
                    }
                )
            )
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
