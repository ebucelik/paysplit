//
//  OpenExpenseView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture
import OneSignalFramework

struct OpenExpenseView: View {

    @Bindable
    var store: StoreOf<OpenExpenseCore>

    var body: some View {
        VStack {
            switch store.openExpenses {
            case .none:
                InfoView(
                    state: .emptyPayments,
                    message: "No open expenses available at the moment. All splitted bills were paid.",
                    refreshableAction: {
                        await store.send(.loadOpenExpenses).finish()
                    }
                )

            case .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let openExpenses), .refreshing(let openExpenses):
                HStack {
                    Menu {
                        Picker("Filter", selection: $store.filter) {
                            ForEach(OpenExpenseCore.State.FilterKeys.allCases, id: \.self) { filterKey in
                                Text(filterKey.rawValue)
                                    .tag(filterKey)
                            }
                        }
                    } label: {
                        Text(store.filter.rawValue)
                            .font(.app(.body1(.regular)))
                    }

                    Spacer()

                    Menu {
                        Picker("Sorting", selection: $store.sorting) {
                            ForEach(OpenExpenseCore.State.SortingKeys.allCases, id: \.self) { sortingKey in
                                Text(sortingKey.rawValue)
                                    .tag(sortingKey)
                            }
                        }
                    } label: {
                        Text(store.sorting.rawValue)
                            .font(.app(.body1(.regular)))
                    }
                }
                .padding(.top, 16)

                if openExpenses.isEmpty {
                    InfoView(
                        state: .emptyPayments,
                        message: "No open expenses available at the moment. All splitted bills were paid.",
                        refreshableAction: {
                            await store.send(.loadOpenExpenses).finish()
                        }
                    )
                } else {
                    List(openExpenses, id: \.id) { openExpense in
                        HStack(spacing: 16) {
                            if openExpense.creatorId == store.account?.id {
                                Image("getPayment")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.app(.success))
                            } else {
                                Image("givePayment")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.app(.error))
                            }

                            VStack {
                                Spacer()

                                HStack(spacing: 4) {
                                    PaysplitImage(
                                        picture: openExpense.creatorPictureLink,
                                        frame: CGSize(
                                            width: 30,
                                            height: 30
                                        )
                                    )

                                    Text(openExpense.creatorName)
                                        .font(.app(.subtitle1(.regular)))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Spacer()
                                }

                                Text(openExpense.creatorUsername)
                                    .font(.app(.body2(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(openExpense.expenseDescription)
                                    .font(.app(.body2(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(openExpense.timestamp.toStringDate), \(openExpense.timestamp.toStringTime)")
                                    .font(.app(.body2(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Spacer()
                            }

                            Spacer()

                            Text("\(openExpense.creatorId == store.account?.id ? "+" : "-") \(openExpense.expenseAmount) €")
                                .font(.app(.subtitle1(.bold)))
                                .frame(alignment: .trailing)
                                .foregroundStyle(Color.app(openExpense.creatorId == store.account?.id ? .success : .error))
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.presentUpdateExpenseSheet(openExpense))
                        }
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(.plain)
                    .id(UUID())
                    .refreshable {
                        await store.send(.loadOpenExpenses).finish()
                    }
                }

            case .error:
                InfoView(
                    state: .emptyPayments,
                    message: "An error occured.",
                    refreshableAction: {
                        await store.send(.loadOpenExpenses).finish()
                    }
                )
            }
        }
        .onChange(of: store.filter) { _, _ in
            store.send(.filterChanged)
        }
        .onChange(of: store.sorting) { _, _ in
            store.send(.sortingChanged)
        }
        .onAppear {
            store.send(.onViewAppear)
        }
        .padding(.horizontal, 4)
        .onReceive(NotificationCenter.default.publisher(for: .accountIsSet)) { @MainActor _ in
            store.send(.loadOpenExpenses)

            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                if let error = error {
                    print(error)
                } else if success {
                    OneSignal.User.pushSubscription.optIn()
                }
            }
        }
        .sheet(item: $store.updateOpenExpense) { updateOpenExpense in
            VStack {
                Text(updateOpenExpense.expenseDescription)
                    .font(.app(.title2(.bold)))
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer()

                Image("givePayment")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.app(.error))

                Spacer()

                HStack(spacing: 8) {
                    Spacer()

                    PaysplitImage(
                        picture: updateOpenExpense.creatorPictureLink,
                        frame: CGSize(
                            width: 40,
                            height: 40
                        )
                    )

                    Text(updateOpenExpense.creatorName)
                        .font(.app(.subtitle(.regular)))
                        .frame(alignment: .leading)

                    Spacer()
                }

                Spacer()

                Text(updateOpenExpense.creatorUsername)
                    .font(.app(.body1(.regular)))
                    .frame(alignment: .leading)

                Text(updateOpenExpense.expenseDescription)
                    .font(.app(.body1(.regular)))
                    .frame(alignment: .leading)

                Text("\(updateOpenExpense.timestamp.toStringDate), \(updateOpenExpense.timestamp.toStringTime)")
                    .font(.app(.body1(.regular)))
                    .frame(alignment: .leading)

                Spacer()

                PaysplitButton(
                    title: "Mark \(updateOpenExpense.expenseAmount) € as paid",
                    isLoading: store.updatedExpense.isLoading
                ) {
                    store.send(.updateOpenExpense(updateOpenExpense, true))
                }
            }
            .padding(16)
            .presentationDetents([.medium])
        }
    }
}
