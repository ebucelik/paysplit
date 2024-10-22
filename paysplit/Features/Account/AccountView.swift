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

                if case let .loaded(statistics) = store.accountStatistics {
                    statisticsBody(statistics)
                } else if case let .refreshing(statistics) = store.accountStatistics {
                    statisticsBody(statistics)
                }

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

                credits()
            }
            .padding()
        }
        .onAppear {
            store.send(.onViewAppear)
        }
    }

    @ViewBuilder
    private func statisticsBody(_ statistics: AccountStatistics) -> some View {
        VStack {
            VStack{
                Text("Statistics")
                    .font(.app(.title2(.bold)))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Your activities summed up for each category.")
                    .font(.app(.subtitle1(.regular)))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 16)
            .padding(.bottom, 16)

            VStack(spacing: 24) {
                HStack {
                    VStack(spacing: 8) {
                        Text("Added Friends")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.addedFriends)")
                            .font(.app(.title2(.bold)))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    VStack(spacing: 8) {
                        Text("Added Expenses")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.addedExpenses)")
                            .font(.app(.title2(.bold)))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                HStack {
                    VStack(spacing: 8) {
                        Text("Paid Debts")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.paidDebts != "0" ? "-" : "") \(statistics.paidDebts) €")
                            .font(.app(.title2(.bold)))
                            .foregroundStyle(Color.app(statistics.paidDebts != "0" ? .error : .primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    VStack(spacing: 8) {
                        Text("Open Debts")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.openDebts != "0" ? "-" : "") \(statistics.openDebts) €")
                            .font(.app(.title2(.bold)))
                            .foregroundStyle(Color.app(statistics.openDebts != "0" ? .error : .primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                HStack {
                    VStack(spacing: 8) {
                        Text("Received Debts")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.receivedDebts != "0" ? "+" : "") \(statistics.receivedDebts) €")
                            .font(.app(.title2(.bold)))
                            .foregroundStyle(Color.app(statistics.receivedDebts != "0" ? .success : .primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    VStack(spacing: 8) {
                        Text("Expected Debts")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.expectedDebts != "0" ? "+" : "") \(statistics.expectedDebts) €")
                            .font(.app(.title2(.bold)))
                            .foregroundStyle(Color.app(statistics.expectedDebts != "0" ? .success : .primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

                HStack {
                    VStack(spacing: 8) {
                        Text("Highest Received Debt")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.highestReceivedDebt != "0" ? "+" : "") \(statistics.highestReceivedDebt) €")
                            .font(.app(.title2(.bold)))
                            .foregroundStyle(Color.app(statistics.highestReceivedDebt != "0" ? .success : .primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    VStack(spacing: 8) {
                        Text("Highest Paid Debt")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)

                        Text("\(statistics.highestPaidDebt != "0" ? "-" : "") \(statistics.highestPaidDebt) €")
                            .font(.app(.title2(.bold)))
                            .foregroundStyle(Color.app(statistics.highestPaidDebt != "0" ? .error : .primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private func credits() -> some View {
        VStack {
            VStack{
                Text("Credits")
                    .font(.app(.title2(.bold)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 16)
            .padding(.bottom, 16)

            HStack {
                Text("Inspirations & Feedback:")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Text("P. Aydin, S. Djudic")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            HStack {
                Text("Testing:")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Text("P. Aydin, S. Djudic")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            HStack {
                Text("Idea, Concept & Development:")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Text("Ebu Bekir Celik")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Text("Version \(version)")
                    .font(.app(.body(.regular)))
                    .foregroundStyle(Color.app(.info))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 8)
    }
}
