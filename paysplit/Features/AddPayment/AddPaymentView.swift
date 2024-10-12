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

//    VStack {
//        PaysplitTextField(
//            imageSystemName: "square.and.pencil.circle.fill",
//            text: $store.expenseDescription,
//            prompt: Text("Expense description (e.g. Pizza)")
//        )
//
//        PaysplitTextField(
//            imageSystemName: "eurosign.circle.fill",
//            text: $store.expenseAmount,
//            prompt: Text("0,00")
//        )
//        .keyboardType(.decimalPad)
//        .textSelection(.disabled)
//    }
//    .padding(.horizontal, 16)

    @State
    var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                SearchAddedPeopleView(
                    store: Store(
                        initialState: SearchAddedPeopleCore.State(account: store.account),
                        reducer: {
                            SearchAddedPeopleCore()
                        }
                    )
                )

                Spacer()

                PaysplitButton(title: "Next Step") {
                    store.send(.evaluateNextStep)

                    if let addPaymentStep = store.addPaymentStep {
                        navigationPath.append(addPaymentStep)
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .padding(.horizontal)
            .onAppear {
                store.send(.onViewAppear)
            }
            .navigationTitle("Add Payment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: AddPaymentStep.self) { destination in
                switch destination {
                case .searchPeople:
                    EmptyView()

                case .fullAmount:
                    Text("Full")
                        .onAppear {
                            store.send(.setCurrentStep(.fullAmount))
                        }

                case .splitAmount:
                    Text("Split")
                        .onAppear {
                            store.send(.setCurrentStep(.splitAmount))
                        }

                case .sendPushNotification:
                    Text("Push")
                }

                PaysplitButton(title: "Next Step") {
                    store.send(.evaluateNextStep)

                    if let addPaymentStep = store.addPaymentStep {
                        navigationPath.append(addPaymentStep)
                    }
                }
            }
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
        }
    }
}
