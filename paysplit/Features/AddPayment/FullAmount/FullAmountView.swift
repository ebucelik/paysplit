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

            PaysplitTextField(
                imageSystemName: "square.and.pencil.circle.fill",
                text: $store.expenseDescription,
                prompt: Text("Expense description (e.g. Pizza)")
            )

            PaysplitTextField(
                imageSystemName: "eurosign.circle.fill",
                text: $store.expenseAmount,
                prompt: Text("0,00")
            )
            .keyboardType(.decimalPad)
            .textSelection(.disabled)

            Spacer()

            if !store.expenseDescription.isEmpty,
               !store.expenseAmount.isEmpty {
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
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
