//
//  Alertable.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 24.01.2021.
//

import UIKit

protocol Alertable: UIViewController {
    func showAlert(title: String, message: String)
}

extension Alertable {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)

        self.navigationController?.present(alertController, animated: true)
    }
}
