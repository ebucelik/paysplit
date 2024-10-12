//
//  AddPaymentStep.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 12.10.24.
//

enum AddPaymentStep: String, Hashable, CaseIterable {
    case searchPeople
    case fullAmount
    case splitAmount
    case sendPushNotification

    func nextStep() -> AddPaymentStep? {
        switch self {
        case .searchPeople:
            return .fullAmount
        case .fullAmount:
            return .splitAmount
        case .splitAmount:
            return .sendPushNotification
        case .sendPushNotification:
            return nil
        }
    }
}
