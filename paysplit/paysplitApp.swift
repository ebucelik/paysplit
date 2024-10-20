//
//  paysplitApp.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 02.08.24.
//

import SwiftUI
import ComposableArchitecture
import OneSignalFramework

@main
struct paysplitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppCore.State(),
                    reducer: {
                        AppCore()
                    },
                    withDependencies: {
                        $0.entryService = EntryServiceKey.liveValue
                        $0.accountService = AccountServiceKey.liveValue
                        $0.addPeopleService = AddPeopleServiceKey.liveValue
                        $0.addExpenseService = AddExpenseServiceKey.liveValue
                        $0.expenseOverviewService = ExpenseOverviewServiceKey.liveValue
                        $0.expenseDetailService = ExpenseDetailServiceKey.liveValue
                        $0.openExpenseService = OpenExpenseServiceKey.liveValue
                        $0.paidExpenseService = PaidExpenseServiceKey.liveValue
                    }
                )
            )
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Remove this method to stop OneSignal Debugging
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)

        // OneSignal initialization
        OneSignal.initialize(OneSignalClient.appId, withLaunchOptions: launchOptions)

        // requestPermission will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)

        OneSignal.User.setLanguage(Locale.current.language.languageCode?.identifier ?? "en")

        OneSignal.User.pushSubscription.optIn()

        // Login your customer with externalId
        // OneSignal.login("EXTERNAL_ID")

        return true
    }
}
