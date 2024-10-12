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
        if store.showOverview {
            TabView(selection: $store.selectedTab) {
                OverviewView(
                    store: store.scope(state: \.overview, action: \.overview)
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

                AccountView(
                    store: store.scope(state: \.accountState, action: \.account)
                )
                .tabItem {
                    Image(systemName: "person.crop.square.fill")
                }
                .tag(2)
            }
            .onAppear {
                store.send(.onViewAppear)
            }
            .onReceive(NotificationCenter.default.publisher(for: .logout)) { @MainActor _ in
                store.send(.logout)
            }
            .tint(.app(.primary))
            .onChange(of: store.selectedTab) {
                if store.selectedTab == 1 {
                    store.state.setSelectedTab()

                    store.send(.showAddPaymentView)
                } else {
                    store.state.setPreviousSelectedTab()
                }
            }
            .fullScreenCover(
                item: $store.scope(
                    state: \.addPayment,
                    action: \.addPayment
                )
            ) { addPaymentCore in
                AddPaymentView(store: addPaymentCore)
            }
            .fullScreenCover(
                item: $store.scope(
                    state: \.entry,
                    action: \.entry
                )
            ) { entryCore in
                EntryView(store: entryCore)
            }
        } else {
            LaunchScreenView(showOverview: $store.showOverview)
        }
    }
}
