//
//  AccountView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import SwiftUI
import ComposableArchitecture

struct AccountView: View {

    let store: StoreOf<AccountCore>

    var body: some View {
        if case let .loaded(account) = store.accountState {
            Text(account.username)
        }
    }
}
