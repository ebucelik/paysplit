//
//  PaidPaymentView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct PaidPaymentView: View {

    let store: StoreOf<PaidPaymentCore>

    var body: some View {
        VStack {
            switch store.paidPayments {
            case .none, .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let paidPayments), .refreshing(let paidPayments):
                List(paidPayments, id: \.id) { paidPayment in
                    HStack(spacing: 16) {
                        VStack {
                            Spacer()

                            Text("\(paidPayment.firstname) \(paidPayment.lastname)")
                                .font(.app(.subtitle1(.regular)))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(paidPayment.username)
                                .font(.app(.body2(.regular)))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                        }

                        Spacer()

                        Text("\(paidPayment.amount) \(paidPayment.currencyCode)")
                            .font(.app(.subtitle1(.regular)))
                            .frame(alignment: .trailing)

                        switch paidPayment.transactionStatus {
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
                    await store.send(.loadPaidPayments).finish()
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
