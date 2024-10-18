//
//  ExpenseDetailView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

import SwiftUI
import ComposableArchitecture

struct ExpenseDetailView: View {

    let store: StoreOf<ExpenseDetailCore>

    var body: some View {
        VStack {
            Text("\(store.expense.expenseDescription)")
                .font(.app(.title2(.bold)))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("All persons who owns you money are listed here.")
                .font(.app(.subtitle1(.regular)))
                .frame(maxWidth: .infinity, alignment: .leading)

            switch store.expenseDetails {
            case .none:
                InfoView(
                    state: .general,
                    message: "No expenses found.",
                    refreshableAction: {
                        await store.send(.loadExpenseDetails).finish()
                    }
                )

            case .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let expenseDetails), .refreshing(let expenseDetails):
                if expenseDetails.isEmpty {
                    InfoView(
                        state: .general,
                        message: "No expenses found. Add your first expense now.",
                        refreshableAction: {
                            await store.send(.loadExpenseDetails).finish()
                        }
                    )
                } else {
                    List(expenseDetails, id: \.id) { expenseDetail in
                        HStack(spacing: 16) {
                            VStack {
                                Spacer()

                                Text(
                                    expenseDetail.debtorId == store.account?.id
                                    ? "You"
                                    : expenseDetail.debtorName
                                )
                                .font(.app(.subtitle1(.regular)))
                                .foregroundStyle(Color.app(.primary))
                                .frame(maxWidth: .infinity, alignment: .leading)

                                if expenseDetail.debtorId != store.account?.id {
                                    Text(expenseDetail.debtorUsername)
                                        .font(.app(.body2(.regular)))
                                        .foregroundStyle(Color.app(.primary))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                Spacer()
                            }

                            Spacer()

                            Text("\(expenseDetail.expenseAmount) €")
                                .font(.app(.subtitle1(.bold)))
                                .foregroundStyle(Color.app(.primary))
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            if expenseDetail.paid {
                                Image(systemName: "checkmark.circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.app(.success))
                            } else {
                                Image(systemName: "questionmark.circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color.app(.info))
                            }
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await store.send(.loadExpenseDetails).finish()
                    }

                    Divider()

                    HStack {
                        Text("\(store.expense.timestamp.toStringDate), \(store.expense.timestamp.toStringTime)")
                            .font(.app(.subtitle1(.regular)))
                            .frame(alignment: .leading)

                        Spacer()

                        Text("Total: ")
                            .font(.app(.subtitle1(.regular)))
                            .frame(alignment: .trailing)

                        Text("\(store.expense.expenseAmount) €")
                            .font(.app(.subtitle1(.bold)))
                            .frame(alignment: .leading)
                    }
                    .padding(.bottom, 30)
                }

            case let .error(error):
                InfoView(
                    state: .general,
                    message: error.asErrorResponse?.message ?? "An error occured.",
                    refreshableAction: {
                        await store.send(.loadExpenseDetails).finish()
                    }
                )
            }
        }
        .padding(16)
        .onAppear {
            store.send(.onViewAppear)
        }
    }
}
