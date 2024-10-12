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
                Color.app(.secondary)

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

//                            if case let .loaded(addedPeople) = store.people,
//                               addedPeople.contains(where: { $0.id == person.id }) {
//                                Image(systemName: "checkmark.square.fill")
//                                    .renderingMode(.template)
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundStyle(Color.app(.success))
//                            } else if store.selectedIdToAdd == person.id {
//                                ProgressView()
//                                    .progressViewStyle(.circular)
//                                    .frame(width: 30, height: 30)
//                            } else {
//                                Button {
//                                    store.send(.addPerson(person.id))
//                                } label: {
//                                    Image(systemName: "plus.app")
//                                        .resizable()
//                                        .frame(width: 30, height: 30)
//                                }
//                                .buttonStyle(.plain)
//                            }
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
