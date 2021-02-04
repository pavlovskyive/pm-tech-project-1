//
//  Alertable.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 24.01.2021.
//

import UIKit

/*
 Mentor's comment:
 Alertable means that an entity that implements this protocol may be used as an alert)
 Alertable -> AlertPresenting.
 
 Perhaps this functionality can be added by just using extension.
 */
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
