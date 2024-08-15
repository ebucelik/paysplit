//
//  InfoView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 15.08.24.
//

import SwiftUI
import Lottie

struct InfoView: View {
    enum State: String {
        case general
        case emptyPayments
        case failedPayment
        case successPayment

        var colorForFailedPayment: Color {
            if case .failedPayment = self {
                return .app(.error)
            }

            return .app(.primary)
        }
    }

    let state: State
    let message: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?

    init(
        state: State,
        message: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.state = state
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    var body: some View {
        VStack(alignment: .center, spacing: 48) {
            Spacer()

            Group {
                if case .successPayment = state {
                    LottieView(animation: .named(state.rawValue))
                        .resizable()
                        .playing(loopMode: .playOnce)
                        .frame(width: 100, height: 100)
                } else {
                    Image(state.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 80, height: 80)
                        .foregroundStyle(state.colorForFailedPayment)
                }

                Text(message)

                if let buttonTitle, let buttonAction {
                    Spacer()

                    PaysplitButton(
                        title: buttonTitle,
                        action: buttonAction
                    )
                } else {
                    Spacer()
                }
            }
            .font(.app(.body(.bold)))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    InfoView(
        state: .successPayment,
        message: "No open payments found.",
        buttonTitle: "Retry",
        buttonAction: {}
    )
}
