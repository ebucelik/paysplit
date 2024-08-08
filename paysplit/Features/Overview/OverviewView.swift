//
//  OverviewView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 07.08.24.
//

import SwiftUI
import ComposableArchitecture

struct OverviewView: View {

    @Bindable
    var store: StoreOf<OverviewCore>

    init(store: StoreOf<OverviewCore>) {
        self.store = store

        UISegmentedControl.appearance().selectedSegmentTintColor = .black
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker(
                    "",
                    selection: $store.selection
                ) {
                    Text(OverviewCore.State.OverviewSelection.people.rawValue)
                        .tag(OverviewCore.State.OverviewSelection.people)

                    Text(OverviewCore.State.OverviewSelection.open.rawValue)
                        .tag(OverviewCore.State.OverviewSelection.open)

                    Text(OverviewCore.State.OverviewSelection.paid.rawValue)
                        .tag(OverviewCore.State.OverviewSelection.paid)
                }
                .pickerStyle(.segmented)
                .tint(.black)

                switch store.selection {
                case .people:
                    PeopleView(store: store.scope(state: \.people, action: \.people))

                case .open:
                    OpenPaymentView(store: store.scope(state: \.openPayment, action: \.openPayment))

                case .paid:
                    PaidPaymentView(store: store.scope(state: \.paidPayment, action: \.paidPayment))
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("appIconNoBackground")
                        .resizable()
                        .frame(width: 70, height: 70)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            print("add people")
                        }, label: {
                            Image(systemName: "person.fill.badge.plus")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .tint(.black)
                        }
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
