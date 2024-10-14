//
//  AddPaymentView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct AddPaymentView: View {

    @Bindable
    var store: StoreOf<AddPaymentCore>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                SearchAddedPeopleView(
                    store: store.scope(
                        state: \.searchAddedPeople,
                        action: \.searchAddedPeople
                    )
                )
            }
            .padding(.horizontal)
            .onAppear {
                store.send(.onViewAppear)
            }
            .navigationTitle("Add Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            store.send(.delegate(.dismiss))
                        },
                        label: {
                            Text("Cancel")
                                .font(.app(.subtitle(.regular)))
                                .foregroundStyle(Color.app(.primary))
                        }
                    )
                }
            }
        } destination: { store in
            switch store.case {
            case .fullAmount(let store):
                FullAmountView(store: store)
                    .onAppear {
                        if self.store.addPaymentStep != .fullAmount {
                            self.store.send(.setCurrentStep(.fullAmount))
                        }
                    }

            case .splitAmount(let store):
                SplitAmountView(store: store)
                    .onAppear {
                        if self.store.addPaymentStep != .splitAmount {
                            self.store.send(.setCurrentStep(.splitAmount))
                        }
                    }
            }
        }
        .tint(Color.app(.primary))
    }
}
