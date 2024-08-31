//
//  PaysplitButton.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 15.08.24.
//

import SwiftUI

struct PaysplitButton: View {

    let title: String
    let isDisabled: Bool
    let isLoading: Bool
    let action: () -> Void

    init(
        title: String,
        isDisabled: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                HStack {
                    Spacer()

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.app(.secondary))
                    } else {
                        Text(title)
                            .font(.app(.subtitle(.bold)))
                            .foregroundStyle(Color.app(.secondary))
                    }

                    Spacer()
                }
                .padding()
                .background(Color.app(.primary).opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(color: Color.app(.info), radius: 6)
            }
        )
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.8 : 1)
    }
}

#Preview {
    PaysplitButton(
        title: "Pay now",
        action: {}
    )
}
