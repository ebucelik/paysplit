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
            VStack {
                if case let .loaded(account) = store.accountState {
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
                                            .overlay {
                                                Circle()
                                                    .stroke(.white, lineWidth: 1)
                                            }
                                            .position(
                                                x: 80,
                                                y: (proxy.size.height / 2) + 40
                                            )

                                        VStack(alignment: .leading) {
                                            Text("\(account.firstname) \(account.lastname)")
                                                .font(.app(.title2(.bold)))
                                                .foregroundStyle(Color.app(.secondary))

                                            Text("@\(account.username)")
                                                .font(.app(.body1(.regular)))
                                                .foregroundStyle(Color.app(.secondary))
                                        }
                                        .position(
                                            x: (proxy.size.width / 2) + 20,
                                            y: (proxy.size.height / 2) + 20
                                        )
                                    }
                                }
                                .frame(height: 100)
                            }
                            .padding(.bottom, 40)

                            Divider()

                            Button {
                                print("logout")
                            } label: {
                                Text("Logout")
                                    .font(.app(.body(.regular)))
                                    .foregroundStyle(Color.app(.primary))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.vertical, 4)

                            Divider()

                            Button {
                                print("delete")
                            } label: {
                                Text("Delete Account")
                                    .font(.app(.body(.regular)))
                                    .foregroundStyle(Color.app(.error))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.vertical, 4)

                            Divider()
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
