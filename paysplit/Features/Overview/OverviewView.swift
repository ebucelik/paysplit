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
            VStack(spacing: 0) {
                if let account = store.account {
                    Text("Welcome \(account.firstname)")
                        .font(.app(.subtitle(.bold)))
                        .foregroundStyle(Color.app(.primary))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                }

                Picker(
                    "",
                    selection: $store.selection
                ) {
                    Text(OverviewCore.State.OverviewSelection.open.rawValue)
                        .tag(OverviewCore.State.OverviewSelection.open)

                    Text(OverviewCore.State.OverviewSelection.paid.rawValue)
                        .tag(OverviewCore.State.OverviewSelection.paid)
                }
                .pickerStyle(.segmented)
                .tint(.black)

                switch store.selection {
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
                    NavigationLink {
                        AddPeopleView(store: store.scope(state: \.addPeople, action: \.addPeople))
                    } label: {
                        Image(systemName: "person.fill.badge.plus")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .tint(.black)
                    }

                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
