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
                    Text("Welcome \(account.firstname)!")
                        .font(.app(.title2(.bold)))
                        .foregroundStyle(Color.app(.primary))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Keep track of open and paid expenses.")
                        .font(.app(.subtitle1(.regular)))
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
                    OpenExpenseView(store: store.scope(state: \.openExpense, action: \.openExpense))

                case .paid:
                    PaidExpenseView(store: store.scope(state: \.paidExpense, action: \.paidExpense))
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
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .tint(Color.app(.primary))
                    }

                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
