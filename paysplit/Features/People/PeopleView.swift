//
//  PeopleView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct PeopleView: View {

    let store: StoreOf<PeopleCore>

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
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(people, id: \.id) { person in
                            HStack(spacing: 8) {
                                if let image = person.image {
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

                                Text(person.firstname)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .refreshable {
                    await store.send(.loadAddedPeople).finish()
                }
                .padding(.top)

            case .error:
                Text("Error occurde")
            }
        }
        .onAppear {
            store.send(.onViewAppear)
        }
    }
}
