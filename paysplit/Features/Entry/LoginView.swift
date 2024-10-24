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
                    Text("Welcome back")
                        .font(.app(.title2(.bold)))
                        .foregroundStyle(Color.app(.primary))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("To use the app please login with your personal info.")
                        .font(.app(.body(.regular)))
                        .foregroundStyle(Color.app(.primary))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 16)

                VStack(spacing: 8) {
                    PaysplitTextField(
                        imageSystemName: "person.circle.fill",
                        text: $store.authenticationRequest.username,
                        prompt: Text("Username"),
                        maxCharacterCount: 30
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.username)

                    PaysplitTextField(
                        imageSystemName: "lock.circle.fill",
                        text: $store.authenticationRequest.password,
                        prompt: Text("Password"),
                        isSecure: true,
                        maxCharacterCount: 50
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.password)

                    if store.authorizationState.isError {
                        Text("Username or Password invalid.")
                            .font(.app(.body(.regular)))
                            .foregroundStyle(Color.app(.error))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.vertical, 48)

                Spacer()

                PaysplitButton(
                    title: "Sign In",
                    isDisabled: store.isAuthenticationRequestInvalid,
                    isLoading: store.authorizationState.isLoading,
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
                UniversalHelper.resignFirstResponder()
            }
        }
        .background(Color.app(.primary))
    }
}
