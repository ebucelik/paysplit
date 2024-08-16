//
//  OpenPaymentView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct OpenPaymentView: View {

    let store: StoreOf<OpenPaymentCore>

    var body: some View {
        VStack {
            switch store.openPayments {
            case .none, .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let openPayments), .refreshing(let openPayments):
                if openPayments.isEmpty {
                    InfoView(
                        state: .emptyPayments,
                        message: "No open payments available at the moment. All splitted bills were paid.",
                        refreshableAction: {
                            await store.send(.loadOpenPayments).finish()
                        }
                    )
                } else {
                    List(openPayments, id: \.id) { openPayment in
                        HStack(spacing: 16) {
                            Group {
                                if openPayment.expectsPayment {
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

                                    Text("\(openPayment.firstname) \(openPayment.lastname)")
                                        .font(.app(.subtitle1(.regular)))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text(openPayment.username)
                                        .font(.app(.body2(.regular)))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Spacer()
                                }

                                Spacer()

                                Text("\(openPayment.amount) \(openPayment.currencyCode)")
                                    .font(.app(.subtitle1(.regular)))
                                    .frame(alignment: .trailing)
                            }
                            .foregroundStyle(Color.app(openPayment.expectsPayment ? .error : .success))
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await store.send(.loadOpenPayments).finish()
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
