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
            TabView {
                OverviewView(
                    store: store.scope(state: \.overview, action: \.overview)
                )
                .tabItem {
                    Image(systemName: "globe.europe.africa")
                }

                ExpenseOverviewView(
                    store: store.scope(state: \.expenseOverview, action: \.expenseOverview)
                )
                .tabItem {
                    Image(systemName: "arrow.down.square.fill")
                }

                AccountView(
                    store: store.scope(state: \.accountState, action: \.account)
                )
                .tabItem {
                    Image(systemName: "person.crop.square.fill")
                }
            }
            .onAppear {
                store.send(.onViewAppear)
            }
            .onReceive(NotificationCenter.default.publisher(for: .logout)) { @MainActor _ in
                store.send(.logout)
            }
            .tint(.app(.primary))
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
