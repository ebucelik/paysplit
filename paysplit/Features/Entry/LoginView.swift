//
//  LoginView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {

    @Bindable
    var store: StoreOf<LoginCore>

    var body: some View {
        VStack {
            Text("Login")
                .font(.app(.title(.bold)))
                .foregroundStyle(Color.app(.secondary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to Paysplit")
                        .font(.app(.title2(.bold)))
                        .foregroundStyle(Color.app(.primary))

                    Text("To use the app please login with your personal info.")
                        .font(.app(.body(.regular)))
                        .foregroundStyle(Color.app(.primary))
                }
                .padding(.top, 16)

                VStack(spacing: 8) {
                    PaysplitTextField(
                        imageSystemName: "person.circle.fill",
                        text: $store.authenticationRequest.username,
                        prompt: Text("Username")
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.username)

                    PaysplitTextField(
                        imageSystemName: "lock.circle.fill",
                        text: $store.authenticationRequest.password,
                        prompt: Text("Password"),
                        isSecure: true
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)
                }
                .padding(.vertical, 48)

                Spacer()

                PaysplitButton(
                    title: "Sign In",
                    isDisabled: store.isAuthenticationRequestEmpty,
                    action: {
                        store.send(.signIn)
                    }
                )

                HStack {
                    Spacer()

                    Text("Don't have an account?")
                        .font(.app(.body(.regular)))
                        .foregroundStyle(Color.app(.primary))

                    Button {
                        store.send(.delegate(.showRegister))
                    } label: {
                        Text("Sign up")
                            .font(.app(.body(.bold)))
                            .foregroundStyle(Color.app(.primary))
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(.bottom, 32)
            }
            .padding(16)
            .background(Color.app(.secondary))
            .clipShape(
                .rect(
                    topLeadingRadius: 8,
                    topTrailingRadius: 8
                )
            )
            .ignoresSafeArea()
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .background(Color.app(.primary))
    }
}
