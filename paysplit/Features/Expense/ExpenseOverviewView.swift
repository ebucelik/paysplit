//
//  ExpenseOverviewView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 17.10.24.
//

import SwiftUI
import ComposableArchitecture

struct ExpenseOverviewView: View {

    @Bindable
    var store: StoreOf<ExpenseOverviewCore>

    var body: some View {
        NavigationStack {
            VStack {
                Text("Expense Overview")
                    .font(.app(.title2(.bold)))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Here you can find your added expenses.")
                    .font(.app(.subtitle1(.regular)))
                    .frame(maxWidth: .infinity, alignment: .leading)

                switch store.groupedExpenses {
                case .none:
                    InfoView(
                        state: .general,
                        message: "No expenses found.",
                        refreshableAction: {
                            await store.send(.loadGroupedExpenses).finish()
                        }
                    )

                case .loading:
                    VStack {
                        Spacer()

                        ProgressView()
                            .progressViewStyle(.circular)

                        Spacer()
                    }

                case .loaded(let groupedExpenses), .refreshing(let groupedExpenses):
                    if groupedExpenses.isEmpty {
                        InfoView(
                            state: .general,
                            message: "No expenses found. Add your first expense now.",
                            refreshableAction: {
                                await store.send(.loadGroupedExpenses).finish()
                            }
                        )
                    } else {
                        List(groupedExpenses, id: \.id) { groupedExpense in
                            NavigationLink {
                                Text("s")
                            } label: {
                                HStack(spacing: 16) {
                                    VStack {
                                        Spacer()

                                        Text(groupedExpense.expenseDescription)
                                            .font(.app(.subtitle1(.regular)))
                                            .foregroundStyle(Color.app(.primary))
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Text("\(groupedExpense.timestamp.toStringDate), \(groupedExpense.timestamp.toStringTime)")
                                            .font(.app(.body2(.regular)))
                                            .foregroundStyle(Color.app(.primary))
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Spacer()
                                    }

                                    Spacer()

                                    Text("\(groupedExpense.expenseAmount) €")
                                        .font(.app(.subtitle1(.bold)))
                                        .foregroundStyle(Color.app(.primary))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .padding(8)
                            .ignoresSafeArea()
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await store.send(.loadGroupedExpenses).finish()
                        }
                    }

                case let .error(error):
                    InfoView(
                        state: .general,
                        message: error.asErrorResponse?.message ?? "An error occured.",
                        refreshableAction: {
                            await store.send(.loadGroupedExpenses).finish()
                        }
                    )
                }

                PaysplitButton(title: "Add Expense") {
                    store.send(.showAddExpense)
                }
            }
            .padding(16)
            .onAppear {
                store.send(.onViewAppear)
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sorting", selection: $store.sorting) {
                            ForEach(ExpenseOverviewCore.State.SortingKeys.allCases, id: \.self) { sortingKey in
                                Text(sortingKey.rawValue)
                                    .tag(sortingKey)
                            }
                        }
                    } label: {
                        Text(store.sorting.rawValue)
                            .font(.app(.body1(.regular)))
                    }
                }
            }
            .onChange(of: store.sorting) { _, _ in
                store.send(.sortingChanged)
            }
            .fullScreenCover(isPresented: $store.isAddExpenseShown) {
                AddExpenseView(store: store.scope(state: \.addExpense, action: \.addExpense))
            }
        }
    }
}
