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
                    Text("Added People")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.app(.subtitle(.bold)))
                        .foregroundStyle(Color.app(.primary))

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
                                message: "No added people available. Search to find new persons to add.",
                                refreshableAction: {
                                    await store.send(.loadAddedPeople).finish()
                                }
                            )
                        } else {
                            List(people, id: \.id) { person in
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
                        }
                    case let .error(error):
                        InfoView(
                            state: .general,
                            message: error.asErrorResponse?.message ?? "An error occured.",
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
            }
        }
        .onAppear {
            store.send(.onViewAppear)
        }
        .padding(.horizontal)
        .searchable(text: $store.searchTerm, prompt: "Search for new People to add")
    }
}
