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
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        GeometryReader { proxy in
                            ZStack {
                                Color
                                    .app(.primary)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 8)
                                    )

                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(.gray)
                                    .position(
                                        x: 80,
                                        y: (proxy.size.height / 2) + 40
                                    )

                                Image("appIconNoBackground")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 8,
                                            bottomTrailingRadius: 8
                                        )
                                    )
                                    .position(
                                        x: proxy.size.width - 19,
                                        y: proxy.size.height - 19
                                    )
                            }
                        }
                        .frame(height: 100)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
