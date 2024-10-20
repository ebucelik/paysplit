//
//  ViewControllerRepresentable.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

import UIKit
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {

    let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
