//
//  OpenExpenseView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct OpenExpenseView: View {

    let store: StoreOf<OpenExpenseCore>

    var body: some View {
        VStack {
            switch store.openExpenses {
            case .none, .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let openExpenses), .refreshing(let openExpenses):
                if openExpenses.isEmpty {
                    InfoView(
                        state: .emptyPayments,
                        message: "No open payments available at the moment. All splitted bills were paid.",
                        refreshableAction: {
                            await store.send(.loadOpenExpenses).finish()
                        }
                    )
                } else {
                    List(openExpenses, id: \.id) { openExpense in
                        HStack(spacing: 16) {
                            Group {
                                if openExpense.expectsPayment {
                                    Image("givePayment")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color.app(.error))
                                } else {
                                    Image("getPayment")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color.app(.success))
                                }

                                VStack {
                                    Spacer()

                                    Text("\(openExpense.firstname) \(openExpense.lastname)")
                                        .font(.app(.subtitle1(.regular)))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text(openExpense.username)
                                        .font(.app(.body2(.regular)))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Spacer()
                                }

                                Spacer()

                                Text("\(openExpense.amount) \(openExpense.currencyCode)")
                                    .font(.app(.subtitle1(.regular)))
                                    .frame(alignment: .trailing)
                            }
                            .foregroundStyle(Color.app(openExpense.expectsPayment ? .error : .success))
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await store.send(.loadOpenExpenses).finish()
                    }
                }

            case .error:
                Text("Error occurde")
            }
        }
        .onAppear {
            store.send(.onViewAppear)
        }
        .padding(.horizontal, 4)
    }
}
