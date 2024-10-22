//
//  PaysplitTextField.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import SwiftUI
import Combine

struct PaysplitTextField: View {

    let imageSystemName: String
    @Binding
    var text: String
    let prompt: Text
    let isSecure: Bool
    let isAmount: Bool
    let maxCharacterCount: Int

    @FocusState var isFocused: Bool

    init(
        imageSystemName: String,
        text: Binding<String>,
        prompt: Text,
        isSecure: Bool = false,
        isAmount: Bool = false,
        maxCharacterCount: Int
    ) {
        self.imageSystemName = imageSystemName
        self._text = text
        self.prompt = prompt
        self.isSecure = isSecure
        self.isAmount = isAmount
        self.maxCharacterCount = maxCharacterCount
    }

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
                    prompt: prompt.font(.app(.subtitle1(.regular)))
                )
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .font(.app(.subtitle1(.regular)))
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: prompt.font(.app(.subtitle1(.regular)))
                )
                .focused($isFocused)
                .frame(maxWidth: .infinity)
                .font(.app(.subtitle1(.regular)))
                .onReceive(Just(text)) { _ in
                    if text.count > maxCharacterCount {
                        text = String(text.prefix(maxCharacterCount))
                    }

                    if isAmount, text.contains(".") {
                        text = text.replacingOccurrences(of: ".", with: ",")
                    }
                }
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
        prompt: Text("Test prompt"),
        maxCharacterCount: 60
    )
}
