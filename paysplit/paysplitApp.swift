//
//  paysplitApp.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 02.08.24.
//

import SwiftUI
import ComposableArchitecture

@main
struct paysplitApp: App {
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
                    }
                )
            )
        }
    }
}
