//
//  RegisterView.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 28.08.24.
//

import ComposableArchitecture
import SwiftUI

struct RegisterView: View {

    @Bindable
    var store: StoreOf<RegisterCore>

    var body: some View {
        VStack {
            Text("Create Your Account")
                .font(.app(.title(.bold)))
                .foregroundStyle(Color.app(.secondary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to Paysplit")
                        .font(.app(.title2(.bold)))
                        .foregroundStyle(Color.app(.primary))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("To use the app please register with your personal info.")
                        .font(.app(.body(.regular)))
                        .foregroundStyle(Color.app(.primary))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 16)

                VStack(spacing: 8) {
                    PaysplitTextField(
                        imageSystemName: "doc.circle.fill",
                        text: $store.registerRequest.firstname,
                        prompt: Text("Firstname"),
                        maxCharacterCount: 30
                    )
                    .autocorrectionDisabled()
                    .textContentType(.givenName)

                    PaysplitTextField(
                        imageSystemName: "doc.circle.fill",
                        text: $store.registerRequest.lastname,
                        prompt: Text("Lastname"),
                        maxCharacterCount: 30
                    )
                    .autocorrectionDisabled()
                    .textContentType(.familyName)

                    PaysplitTextField(
                        imageSystemName: "person.circle.fill",
                        text: $store.registerRequest.username,
                        prompt: Text("Username"),
                        maxCharacterCount: 30
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.username)

                    PaysplitTextField(
                        imageSystemName: "lock.circle.fill",
                        text: $store.registerRequest.password,
                        prompt: Text("Password"),
                        isSecure: true,
                        maxCharacterCount: 50
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.newPassword)

                    PaysplitTextField(
                        imageSystemName: "lock.circle.fill",
                        text: $store.passwordAgain,
                        prompt: Text("Retype Password"),
                        isSecure: true,
                        maxCharacterCount: 50
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.newPassword)

                    if store.registrationState.isError {
                        Text("Something went wrong. Please try again.")
                            .font(.app(.body(.regular)))
                            .foregroundStyle(Color.app(.error))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
//                .padding(.vertical, 32)
                .padding(.horizontal, 1)

                Spacer()

                PaysplitButton(
                    title: "Sign Up",
                    isDisabled: store.isRegistrationRequestInvalid,
                    isLoading: store.registrationState.isLoading,
                    action: {
                        store.send(.signUp)
                    }
                )

                HStack {
                    Spacer()

                    Text("Already have an account?")
                        .font(.app(.body(.regular)))
                        .foregroundStyle(Color.app(.primary))

                    Button {
                        store.send(.delegate(.showLogin))
                    } label: {
                        Text("Sign In")
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
