//
//  String+Extensions.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

public extension String {
    func toTwoDigit() -> String {
        if contains(",") {
            let countOfDecimal = drop(while: { $0 != "," }).dropFirst().count

            return countOfDecimal == 1 ? "\(self)0" : self
        }

        return self
    }
}
