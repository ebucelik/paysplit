//
//  SplitAmountView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import SwiftUI
import ComposableArchitecture

struct SplitAmountView: View {

    @Bindable
    var store: StoreOf<SplitAmountCore>

    var body: some View {
        VStack {
            Text("Last Step")
                .font(.app(.title2(.bold)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.app(.primary))

            Text("Split the expense onto the added people.")
                .font(.app(.subtitle1(.regular)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.app(.primary))

            Spacer()
                .frame(height: 50)

            HStack(spacing: 8) {
                Text("Full Amount for \(store.expenseDescription): ")
                    .font(.app(.subtitle1(.regular)))
                    .frame(alignment: .leading)
                    .foregroundStyle(Color.app(.primary))

                Text("\(store.expenseAmount) €")
                    .font(.app(.subtitle1(.bold)))
                    .frame(alignment: .leading)
                    .foregroundStyle(Color.app(store.isExpensesAmountFulfilled ? .success : .primary))
            }

            Divider()

            List(
                Array(store.addedPeople.enumerated()),
                id: \.offset
            ) { index, person in
                HStack(spacing: 16) {
                    if !person.picturelink.isEmpty {
                        // TODO: load image from server
                        Image(systemName: "person.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.gray)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.gray)
                    }

                    VStack {
                        Spacer()

                        Text("\(person.firstname) \(person.lastname)")
                            .font(.app(.subtitle1(.regular)))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(person.username)
                            .font(.app(.body2(.regular)))
                            .foregroundStyle(Color.app(.divider))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()
                    }

                    Spacer()

                    PaysplitTextField(
                        imageSystemName: "eurosign.circle.fill",
                        text: $store.expenses[index].expenseAmount,
                        prompt: Text("0,00")
                    )
                    .keyboardType(.decimalPad)
                    .textSelection(.disabled)
                }
                .padding(8)
                .ignoresSafeArea()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

            Spacer()

            if store.expenses.allSatisfy({ !$0.expenseAmount.isEmpty }),
               store.isExpensesAmountFulfilled {
                PaysplitButton(
                    title: "Create Payment",
                    isLoading: store.createdExpenses.isLoading
                ) {
                    store.send(.createExpenses)
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
