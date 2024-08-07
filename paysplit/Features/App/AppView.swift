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

    @State
    var selectedTab = 0
    @State
    var previousSelectedTab = 0

    var body: some View {
        // TODO: comment out again later.
        //        if showHomeScreen {
        TabView(selection: $selectedTab) {
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

            Color
                .clear
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
        .onChange(of: selectedTab) {
            if selectedTab == 1 {
                selectedTab = previousSelectedTab

                store.send(.showAddPaymentView)
            } else {
                previousSelectedTab = selectedTab
            }
        }
        .sheet(
            item: $store.scope(
                state: \.addPaymentCoreState,
                action: \.addPayment
            )
        ) { addPaymentCore in
            AddPaymentView(store: addPaymentCore)
        }
        //        } else {
        //            LaunchScreenView(showHomeScreen: $store.showOverview)
        //        }
    }
}
