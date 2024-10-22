//
//  FullAmountView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import SwiftUI
import ComposableArchitecture

struct FullAmountView: View {

    @Bindable
    var store: StoreOf<FullAmountCore>

    var body: some View {
        VStack {
            Text("Step 2")
                .font(.app(.title2(.bold)))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Enter the full expense amount.")
                .font(.app(.subtitle1(.regular)))
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
                .frame(height: 50)

            PaysplitTextField(
                imageSystemName: "square.and.pencil.circle.fill",
                text: $store.expenseDescription,
                prompt: Text("Expense description (e.g. Pizza)"),
                maxCharacterCount: 30
            )

            PaysplitTextField(
                imageSystemName: "eurosign.circle.fill",
                text: $store.expenseAmount,
                prompt: Text("0,00"),
                isAmount: true,
                maxCharacterCount: 7
            )
            .keyboardType(.decimalPad)
            .textSelection(.disabled)

            Spacer()

            if !store.expenseDescription.isEmpty,
               !store.expenseAmount.isEmpty,
               store.isExpensesAmountFulfilled {
                PaysplitButton(title: "Next Step") {
                    store.send(
                        .delegate(
                            .evaluateNextStep(
                                store.expenseDescription,
                                store.expenseAmount
                            )
                        )
                    )
                }
            }
        }
        .padding(16)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
