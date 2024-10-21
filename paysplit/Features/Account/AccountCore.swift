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
        var accountStatistics: ViewState<AccountStatistics> = .none
        var pickedImage: UIImage? = nil
    }

    @CasePathable
    enum Action {
        case onViewAppear
        case loadAccountStatistics
        case setAccountStatistics(ViewState<AccountStatistics>)
        case setAccount(ViewState<Account>)
        case updateUserDefaultAccount(Account)
        case didPickedImage(UIImage?)
        case uploadPickedImage
        case logout
    }

    @Dependency(\.accountService) var service

    var body: some ReducerOf<AccountCore> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .send(.loadAccountStatistics)

            case .loadAccountStatistics:
                guard case let .loaded(account) = state.accountState else { return .none }

                return .run { [accountStatistics = state.accountStatistics] send in
                    if case let .loaded(accountStatistics) = accountStatistics {
                        await send(.setAccountStatistics(.refreshing(accountStatistics)))
                    } else {
                        await send(.setAccountStatistics(.loading))
                    }

                    let accountStatistics = try await self.service.getStatistics(id: account.id)

                    await send(.setAccountStatistics(.loaded(accountStatistics)))
                } catch: { error, send in
                    await send(.setAccountStatistics(.error(error as? MessageResponse ?? error)))
                }

            case let .setAccountStatistics(accountStatistics):
                state.accountStatistics = accountStatistics

                return .none

            case let .setAccount(account):
                state.accountState = account

                return .none

            case let .updateUserDefaultAccount(account):
                do {
                    let accountData = try JSONEncoder().encode(account)
                    UserDefaults.standard.set(accountData, forKey: "account")
                } catch {
                    print("Encoding failed.")
                }

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

                    if !account.picturelink.isEmpty {
                        do {
                            _ = try await self.service.deleteImage(link: account.picturelink)
                        } catch {
                            print("Image could not be deleted.")
                        }
                    }

                    let pictureLink = try await self.service.uploadImage(imageData: jpegData)

                    let updatedAccount = try await self.service.updatePictureLink(id: account.id, link: pictureLink)

                    await send(.setAccount(.loaded(updatedAccount)))
                    await send(.updateUserDefaultAccount(updatedAccount))
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
