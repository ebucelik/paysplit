//
//  AccountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 08.08.24.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct AccountCore {
    @ObservableState
    struct State: Equatable {
        var accountState: ViewState<Account>
        var pickedImage: UIImage? = nil
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case setAccount(ViewState<Account>)
        case didPickedImage(UIImage?)
        case uploadPickedImage
        case logout
    }

    @Dependency(\.accountService) var service

    var body: some ReducerOf<AccountCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .none

            case let .setAccount(account):
                state.accountState = account

                return .none

            case let .didPickedImage(image):
                state.pickedImage = image
                
                return .send(.uploadPickedImage)

            case .uploadPickedImage:
                guard case let .loaded(account) = state.accountState,
                      let pickedImage = state.pickedImage,
                      let jpegData = pickedImage.jpegData(compressionQuality: 1.0) else { return .none }

                return .run { send in
                    await send(.setAccount(.refreshing(account)))

                    let pictureLink = try await self.service.uploadImage(imageData: jpegData)

                    let updatedAccount = try await self.service.updatePictureLink(id: account.id, link: pictureLink)

                    await send(.setAccount(.loaded(updatedAccount)))
                } catch: { error, send in
                    await send(.didPickedImage(nil))
                }

            case .logout:
                return .run { send in
                    _ = try await self.service.logout()
                } catch: { _, _ in
                    print("Logged out.")
                }
            }
        }
    }
}
