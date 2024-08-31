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
        NavigationStack {
            VStack(spacing: 8) {
                switch store.addedPeople {
                case .none, .loading:
                    VStack {
                        Spacer()

                        ProgressView()
                            .progressViewStyle(.circular)

                        Spacer()
                    }

                case .loaded(let addedPeople), .refreshing(let addedPeople):
                    Text("Which people own you money?")
                        .font(.app(.title2(.regular)))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(store.selectedPeople.count) selected")
                        .font(.app(.body(.regular)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.app(.divider))
                        .opacity(store.selectedPeople.count > 0 ? 1 : 0)

                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(addedPeople, id: \.id) { person in
                                VStack(alignment: .center) {
                                    Spacer()

                                    ZStack {
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

                                        if store.selectedPeople.contains(person) {
                                            VStack {
                                                HStack {
                                                    Spacer()

                                                    Image(systemName: "checkmark.circle.fill")
                                                        .renderingMode(.template)
                                                        .resizable()
                                                        .frame(width: 17, height: 17)
                                                        .foregroundStyle(Color.app(.success))
                                                }

                                                Spacer()
                                            }
                                        }
                                    }

                                    Text("\(person.firstname)")
                                        .font(.app(.subtitle1(.regular)))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .lineLimit(1)

                                    Text(person.username)
                                        .font(.app(.body2(.regular)))
                                        .foregroundStyle(Color.app(.divider))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .lineLimit(1)

                                    Spacer()
                                }
                                .onTapGesture {
                                    store.send(.setSelectedPerson(person))
                                }
                            }
                        }
                        .frame(height: 100)

                        Spacer()
                    }
                    .frame(height: 100)
                    .scrollIndicators(.hidden)

                    Spacer()
                        .frame(height: 24)

                    if !store.selectedPeople.isEmpty {
                        VStack {
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
                        }
                        .padding(.horizontal, 16)
                    }

                    Spacer()

                case .error:
                    Text("Error occured")
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .padding(.horizontal)
            .onAppear {
                store.send(.onViewAppear)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("appIconNoBackground")
                        .resizable()
                        .frame(width: 70, height: 70)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            store.send(.delegate(.dismiss))
                        },
                        label: {
                            Text("Close")
                                .font(.app(.subtitle(.regular)))
                                .foregroundStyle(Color.app(.primary))
                        }
                    )
                }
            }
        }
    }
}
