//
//  AppView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 04.08.24.
//

import SwiftUI

struct AppView: View {
    @State
    var showHomeScreen = false

    var body: some View {
        if showHomeScreen {
            TabView {
                VStack {
                    Spacer()

                    Text("Home Screen")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        Image(systemName: "house.fill")
                    }
                }

                VStack {
                    Spacer()

                    Text("Setting Screen")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)

                    Spacer()
                }
                .tabItem {
                    Label {
                        Text("Setting")
                    } icon: {
                        Image(systemName: "gear")
                    }
                }
            }
        } else {
            LaunchScreenView(showHomeScreen: $showHomeScreen)
        }
    }
}
