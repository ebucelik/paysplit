//
//  AppView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {

    @Bindable
    var store: StoreOf<AppCore>

    var body: some View {
        // TODO: comment out again later.
        //        if showHomeScreen {
        TabView(selection: $store.selectedTab) {
            OverviewView(
                store: Store(
                    initialState: OverviewCore.State(),
                    reducer: {
                        OverviewCore()
                    }
                )
            )
            .tabItem {
                Image(systemName: "globe.europe.africa")
            }
            .tag(0)

            VStack {
                Spacer()

                Text("Add pay")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .tabItem {
                Image(systemName: "plus.square.fill")
            }
            .tag(1)

            VStack {
                Spacer()

                Text("Account")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .tabItem {
                Image(systemName: "person.crop.square.fill")
            }
            .tag(2)
        }
        .onChange(of: store.selectedTab) {
            if store.selectedTab == 1 {
                store.selectedTab = store.previousSelectedTab

                store.send(.showAddPaymentView)
            }
        }
        .sheet(item: $store.scope(state: \.addPaymentCoreState, action: \.addPayment)) { addPaymentCore in
            AddPaymentView(store: addPaymentCore)
        }
        //        } else {
        //            LaunchScreenView(showHomeScreen: $store.showOverview)
        //        }
    }
}
