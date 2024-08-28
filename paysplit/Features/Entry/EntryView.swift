//
//  EntryView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture
import SwiftUI

struct EntryView: View {
    let store: StoreOf<EntryCore>

    var body: some View {
        VStack {
            if let loginStore = store.scope(state: \.login, action: \.login.presented) {
                LoginView(store: loginStore)
            } else if let registerStore = store.scope(state: \.register, action: \.register.presented) {
                RegisterView(store: registerStore)
            }
        }
        .onAppear {
            store.send(.onViewAppear)
        }
        .interactiveDismissDisabled()
    }
}
