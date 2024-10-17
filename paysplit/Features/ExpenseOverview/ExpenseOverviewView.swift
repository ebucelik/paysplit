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
                switch store.expenses {
                case .none:
                    InfoView(
                        state: .general,
                        message: "No expenses found.",
                        refreshableAction: {
                            await store.send(.loadExpenses).finish()
                        }
                    )

                case .loading:
                    VStack {
                        Spacer()

                        ProgressView()
                            .progressViewStyle(.circular)

                        Spacer()
                    }

                case .loaded(let expenses), .refreshing(let expenses):
                    if expenses.isEmpty {
                        InfoView(
                            state: .general,
                            message: "No expenses found. Add your first expense now.",
                            refreshableAction: {
                                await store.send(.loadExpenses).finish()
                            }
                        )
                    } else {
                        List(expenses, id: \.id) { expense in
                            NavigationLink {
                                Text("s")
                            } label: {
                                HStack(spacing: 16) {
                                    VStack {
                                        Spacer()

                                        Text(expense.expenseDescription)
                                            .font(.app(.subtitle1(.regular)))
                                            .foregroundStyle(Color.app(.primary))
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Spacer()
                                    }

                                    Spacer()

                                    Text("\(expense.expenseAmount) €")
                                        .font(.app(.subtitle1(.regular)))
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
                            await store.send(.loadExpenses).finish()
                        }
                    }

                case let .error(error):
                    InfoView(
                        state: .general,
                        message: error.asErrorResponse?.message ?? "An error occured.",
                        refreshableAction: {
                            await store.send(.loadExpenses).finish()
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
            .navigationTitle("Expense Overview")
            .navigationBarTitleDisplayMode(.large)
            .fullScreenCover(isPresented: $store.isAddExpenseShown) {
                AddExpenseView(store: store.scope(state: \.addExpense, action: \.addExpense))
            }
        }
    }
}
