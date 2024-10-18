//
//  PaidExpenseView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct PaidExpenseView: View {

    let store: StoreOf<PaidExpenseCore>

    var body: some View {
        VStack {
            switch store.paidExpenses {
            case .none, .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let paidExpenses), .refreshing(let paidExpenses):
                List(paidExpenses, id: \.id) { paidExpense in
                    HStack(spacing: 16) {
                        VStack {
                            Spacer()

                            Text("\(paidExpense.firstname) \(paidExpense.lastname)")
                                .font(.app(.subtitle1(.regular)))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(paidExpense.username)
                                .font(.app(.body2(.regular)))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                        }

                        Spacer()

                        Text("\(paidExpense.amount) \(paidExpense.currencyCode)")
                            .font(.app(.subtitle1(.regular)))
                            .frame(alignment: .trailing)

                        switch paidExpense.transactionStatus {
                        case .pending:
                            Image(systemName: "info.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.app(.info))

                        case .success:
                            Image(systemName: "checkmark.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.app(.success))

                        case .failure:
                            Image(systemName: "xmark.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.app(.error))
                        }
                    }
                    .padding(8)
                    .ignoresSafeArea()
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .refreshable {
                    await store.send(.loadPaidExpenses).finish()
                }

            case .error:
                Text("Error occurd")
            }
        }
        .onAppear {
            store.send(.onViewAppear)
        }
        .padding(.horizontal, 4)
    }
}
