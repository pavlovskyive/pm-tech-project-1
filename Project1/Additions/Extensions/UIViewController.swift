//
//  UIViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 09.02.2021.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) {_ in
            if let completion = completion {
                completion()
            }
        }
        alertController.addAction(OKAction)

        self.navigationController?.present(alertController, animated: true)
    }
}
