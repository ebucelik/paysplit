//
//  AccountView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import SwiftUI
import ComposableArchitecture

struct AccountView: View {

    let imagePickerController = ImagePickerController(placeholder: "")
    let store: StoreOf<AccountCore>

    var body: some View {
        NavigationStack {
            VStack {
                switch store.accountState {
                case let .loaded(account):
                    accountBody(account)

                case let .refreshing(account):
                    accountBody(account)

                case .none, .loading:
                    VStack {
                        Spacer()

                        ProgressView()
                            .progressViewStyle(.circular)

                        Spacer()
                    }

                case .error:
                    InfoView(
                        state: .general,
                        message: "An error occured."
                    )
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    func accountBody(_ account: Account) -> some View {
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

                            PaysplitImage(
                                picture: account.picturelink,
                                frame: CGSize(
                                    width: 100,
                                    height: 100
                                )
                            )
                            .position(
                                x: 80,
                                y: (proxy.size.height / 2) + 40
                            )

                            ViewControllerRepresentable(
                                viewController: imagePickerController
                            )
                            .frame(width: 100, height: 100, alignment: .center)
                            .cornerRadius(50)
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 1)
                            }
                            .onAppear {
                                imagePickerController.onImagePicked = {
                                    store.send(.didPickedImage($0))
                                }
                            }
                            .position(
                                x: 80,
                                y: (proxy.size.height / 2) + 40
                            )
                            .disabled(store.accountState.isLoadingOrRefreshing)

                            HStack {
                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("\(account.firstname) \(account.lastname)")
                                        .font(.app(.title2(.bold)))
                                        .foregroundStyle(Color.app(.secondary))

                                    Text("@\(account.username)")
                                        .font(.app(.body1(.regular)))
                                        .foregroundStyle(Color.app(.secondary))
                                }
                            }
                            .frame(width: proxy.size.width)
                            .position(
                                x: (proxy.size.width / 2) - 20,
                                y: (proxy.size.height / 2) + 20
                            )
                        }
                    }
                    .frame(height: 100)
                }
                .padding(.bottom, 40)

                Divider()

                Button {
                    store.send(.logout)
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
