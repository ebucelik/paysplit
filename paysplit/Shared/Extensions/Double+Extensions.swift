//
//  Double+Extensions.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 18.10.24.
//

import Foundation

extension Double {
    var toStringDate: String {
        let date = Date(timeIntervalSinceReferenceDate: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        dateFormatter.dateFormat = "d. MMM yyyy"

        return dateFormatter.string(from: date)
    }

    var toStringTime: String {
        let date = Date(timeIntervalSinceReferenceDate: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.autoupdatingCurrent
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
    }
}
