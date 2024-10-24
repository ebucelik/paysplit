//
//  UniversalHelper.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 24.10.24.
//

import UIKit

public enum UniversalHelper {
    static func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
