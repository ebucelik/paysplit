//
//  PaysplitTextField.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import SwiftUI

struct PaysplitTextField: View {

    let imageSystemName: String
    @Binding
    var text: String
    let prompt: Text
    let isSecure = false

    @FocusState var isFocused: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: imageSystemName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.app(text.isEmpty ? .info : .primary))

            if isSecure {
                SecureField(
                    "",
                    text: $text,
                    prompt: prompt.font(.app(.subtitle(.regular)))
                )
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .font(.app(.subtitle(.regular)))
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: prompt.font(.app(.subtitle(.regular)))
                )
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .font(.app(.subtitle(.regular)))
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.app(isFocused ? .primary : .info), lineWidth: 1)
        }
    }
}

#Preview {
    PaysplitTextField(
        imageSystemName: "house",
        text: .constant(""),
        prompt: Text("Test prompt")
    )
}
