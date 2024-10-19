//
//  OpenExpenseView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

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

                                Text(openExpense.creatorName)
                                    .font(.app(.subtitle1(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

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

                            Text("\(openExpense.expenseAmount) €")
                                .font(.app(.subtitle1(.bold)))
                                .frame(alignment: .trailing)
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(.plain)
                    .refreshable {
                        await store.send(.loadOpenExpenses).finish()
                    }
                }

            case .error:
                Text("Error occurd")
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
    }
}
