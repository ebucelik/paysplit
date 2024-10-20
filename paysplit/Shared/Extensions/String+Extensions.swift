//
//  String+Extensions.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

import Foundation

public extension String {
    func toTwoDigit() -> String {
        if contains(",") {
            let countOfDecimal = drop(while: { $0 != "," }).dropFirst().count

            return countOfDecimal == 1 ? "\(self)0" : self
        }

        return self
    }

    func localize(defaultLanguage: String = "en", comment: String = "") -> String {
        let value = NSLocalizedString(self, comment: comment)

        if value != self || NSLocale.preferredLanguages.first == defaultLanguage {
            return value
        }

        guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return value }

        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
