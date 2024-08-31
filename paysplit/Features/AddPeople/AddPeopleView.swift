//
//  PeopleView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct AddPeopleView: View {

    let store: StoreOf<AddPeopleCore>

    var body: some View {
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

            case .error:
                Text("Error occured")
            }
        }
        .onAppear {
            store.send(.onViewAppear)
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Added People")
                    .font(.app(.body(.bold)))
            }
        }
    }
}
