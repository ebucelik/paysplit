//
//  RegisterView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture
import SwiftUI

struct RegisterView: View {

    let store: StoreOf<RegisterCore>

    var body: some View {
        VStack {
            Text("Register")

            Button {
                store.send(.delegate(.showLogin))
            } label: {
                Text("Show Login")
            }
        }
    }
}
