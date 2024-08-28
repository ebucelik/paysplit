//
//  PaysplitButton.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 15.08.24.
//

import SwiftUI

struct PaysplitButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                HStack {
                    Spacer()

                    Text(title)
                        .font(.app(.subtitle(.bold)))
                        .foregroundStyle(Color.app(.secondary))

                    Spacer()
                }
                .padding()
                .background(Color.app(.primary).opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(color: Color.app(.info), radius: 6)
            }
        )
        .buttonStyle(.plain)
    }
}

#Preview {
    PaysplitButton(
        title: "Pay now",
        action: {}
    )
}
