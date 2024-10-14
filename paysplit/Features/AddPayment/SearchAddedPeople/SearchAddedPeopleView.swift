//
//  SearchAddedPeopleView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 12.10.24.
//

import SwiftUI
import ComposableArchitecture

struct SearchAddedPeopleView: View {

    @Bindable
    var store: StoreOf<SearchAddedPeopleCore>

    var body: some View {
        VStack {
            switch store.searchAddedPeople {
            case .none:
                VStack {
                    Text("Step 1")
                        .font(.app(.title2(.bold)))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Find added people to split a Payment.")
                        .font(.app(.subtitle1(.regular)))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !store.addedPeopleToSplitAmount.isEmpty {
                        Spacer()
                            .frame(height: 50)

                        Text("\(store.addedPeopleToSplitAmount.count) persons added")
                            .font(.app(.body(.regular)))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.app(.info))

                        List(store.addedPeopleToSplitAmount, id: \.id) { person in
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

                                Button {
                                    store.send(.addOrRemovePerson(person))
                                } label: {
                                    Image(systemName: "checkmark.square.fill")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color.app(.success))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(8)
                            .ignoresSafeArea()
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)

                        PaysplitButton(title: "Next Step") {
                            store.send(.delegate(.evaluateNextStep))
                        }
                    }

                    Spacer()
                }
                .padding(.top)

            case .loading:
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(.circular)

                    Spacer()
                }

            case .loaded(let searchAddedPeople), .refreshing(let searchAddedPeople):
                if searchAddedPeople.isEmpty {
                    InfoView(
                        state: .general,
                        message: "No people found with term \"\(store.searchTerm)\".",
                        refreshableAction: {
                            await store.send(.searchAddedPeople(store.searchTerm)).finish()
                        }
                    )
                } else {
                    List(searchAddedPeople, id: \.id) { person in
                        HStack(spacing: 16) {
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

                            Button {
                                store.send(.addOrRemovePerson(person))
                            } label: {
                                if store.addedPeopleToSplitAmount.contains(where: { $0.id == person.id }) {
                                    Image(systemName: "checkmark.square.fill")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color.app(.success))
                                } else {
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(8)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }

            case let .error(error):
                InfoView(
                    state: .general,
                    message: error.asErrorResponse?.message ?? "An error occured."
                )
            }
        }
        .searchable(text: $store.searchTerm, prompt: "Add people from your List")
    }
}
