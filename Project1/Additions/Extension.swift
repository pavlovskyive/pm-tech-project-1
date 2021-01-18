//
//  Extension.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 18.01.2021.
//

import UIKit

extension UINavigationController {
    func reveal(_ viewController: UIViewController) {
        viewControllers.insert(viewController, at: viewControllers.count - 1)
        setViewControllers(viewControllers, animated: false)
        popViewController(animated: true)
    }
}
