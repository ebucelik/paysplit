//
//  PaidExpenseView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct PaidExpenseView: View {

    @Bindable
    var store: StoreOf<PaidExpenseCore>

    var body: some View {
        VStack {
            switch store.paidExpenses {
            case .none:
                InfoView(
                    state: .emptyPayments,
                    message: "No paid expenses available at the moment.",
                    refreshableAction: {
                        await store.send(.loadPaidExpenses).finish()
                    }
                )

            case .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let paidExpenses), .refreshing(let paidExpenses):
                HStack {
                    Menu {
                        Picker("Filter", selection: $store.filter) {
                            ForEach(PaidExpenseCore.State.FilterKeys.allCases, id: \.self) { filterKey in
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
                            ForEach(PaidExpenseCore.State.SortingKeys.allCases, id: \.self) { sortingKey in
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

                if paidExpenses.isEmpty {
                    InfoView(
                        state: .emptyPayments,
                        message: "No paid expenses available at the moment.",
                        refreshableAction: {
                            await store.send(.loadPaidExpenses).finish()
                        }
                    )
                } else {
                    List(paidExpenses, id: \.id) { paidExpense in
                        HStack(spacing: 16) {
                            if paidExpense.creatorId == store.account?.id {
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

                                Text(paidExpense.creatorName)
                                    .font(.app(.subtitle1(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(paidExpense.creatorUsername)
                                    .font(.app(.body2(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(paidExpense.expenseDescription)
                                    .font(.app(.body2(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text("\(paidExpense.timestamp.toStringDate), \(paidExpense.timestamp.toStringTime)")
                                    .font(.app(.body2(.regular)))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Spacer()
                            }

                            Spacer()

                            Text("\(paidExpense.expenseAmount) €")
                                .font(.app(.subtitle1(.bold)))
                                .frame(alignment: .trailing)

                            Image(systemName: "checkmark.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.app(.success))
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(.plain)
                    .refreshable {
                        await store.send(.loadPaidExpenses).finish()
                    }
                }

            case .error:
                InfoView(
                    state: .emptyPayments,
                    message: "An error occured.",
                    refreshableAction: {
                        await store.send(.loadPaidExpenses).finish()
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
    }
}
