//
//  PeopleView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct AddPeopleView: View {

    @Bindable
    var store: StoreOf<AddPeopleCore>

    var body: some View {
        VStack {
            if store.searchTerm.isEmpty {
                VStack {
                    switch store.people {
                    case .none, .loading:
                        VStack {
                            Spacer()

                            ProgressView()
                                .progressViewStyle(.circular)

                            Spacer()
                        }

                    case .loaded(let people), .refreshing(let people):
                        if people.isEmpty {
                            InfoView(
                                state: .general,
                                message: "Search to find new persons to add.",
                                refreshableAction: {
                                    await store.send(.loadAddedPeople).finish()
                                }
                            )
                        } else {
                            Text("Persons in your list")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.app(.subtitle(.bold)))
                                .foregroundStyle(Color.app(.primary))

                            List(people, id: \.id) { person in
                                HStack(spacing: 16) {
                                    PaysplitImage(
                                        picture: person.picturelink,
                                        frame: CGSize(
                                            width: 50,
                                            height: 50
                                        )
                                    )

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

                                    if store.selectedIdToRemove == person.id {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .frame(width: 30, height: 30)
                                    } else {
                                        Button {
                                            store.send(.removeButtonTapped(id: person.id, username: person.username))
                                        } label: {
                                            Image(systemName: "minus.square.fill")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(Color.app(.primary))
                                        }
                                        .buttonStyle(.plain)
                                        .contentShape(Rectangle())

                                        Button {
                                            store.send(.reportButtonTapped(id: person.id, username: person.username))
                                        } label: {
                                            Image(systemName: "exclamationmark.square.fill")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(Color.app(.warning))
                                        }
                                        .buttonStyle(.plain)
                                        .contentShape(Rectangle())

                                        Button {
                                            store.send(.blockButtonTapped(id: person.id, username: person.username))
                                        } label: {
                                            Image(systemName: "hand.raised.fill")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 25, height: 30)
                                                .foregroundStyle(Color.app(.error))
                                        }
                                        .buttonStyle(.plain)
                                        .contentShape(Rectangle())
                                    }
                                }
                                .padding(8)
                                .ignoresSafeArea()
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .refreshable {
                                await store.send(.loadAddedPeople).finish()
                            }
                            .alert($store.scope(state: \.alert, action: \.alert))
                        }
                    case let .error(error):
                        InfoView(
                            state: .general,
                            message: error.asErrorResponse?.message ?? String(localized: "An error occurred."),
                            refreshableAction: {
                                await store.send(.loadAddedPeople).finish()
                            }
                        )
                    }
                }
            } else {
                VStack {
                    switch store.searchedPeople {
                    case .none:
                        Color.app(.secondary)

                    case .loading:
                        VStack {
                            Spacer()

                            ProgressView()
                                .progressViewStyle(.circular)

                            Spacer()
                        }

                    case .loaded(let searchedPeople), .refreshing(let searchedPeople):
                        if searchedPeople.isEmpty {
                            InfoView(
                                state: .general,
                                message: "No people found with term \"\(store.searchTerm)\".",
                                refreshableAction: {
                                    await store.send(.loadAddedPeople).finish()
                                }
                            )
                        } else {
                            List(searchedPeople, id: \.id) { person in
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

                                    if case let .loaded(addedPeople) = store.people,
                                       addedPeople.contains(where: { $0.id == person.id }) {
                                        Image(systemName: "checkmark.square.fill")
                                            .renderingMode(.template)
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color.app(.success))
                                    } else if store.selectedIdToAdd == person.id {
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                            .frame(width: 30, height: 30)
                                    } else {
                                        Button {
                                            store.send(.addPerson(person.id))
                                        } label: {
                                            Image(systemName: "plus.app")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                        }
                                        .buttonStyle(.plain)
                                    }
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
                            message: error.asErrorResponse?.message ?? String(localized: "An error occurred.")
                        )
                    }
                }
            }
        }
        .navigationTitle("People")
        .onAppear {
            store.send(.onViewAppear)
        }
        .padding(.horizontal)
        .searchable(text: $store.searchTerm, prompt: "Search for new People to add")
    }
}
