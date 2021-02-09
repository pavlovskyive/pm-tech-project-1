//
//  SceneDelegate.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let timer = RepeatingTimer(timeInterval: 1)
        timer.resume()
        let storage = Storage()

        timer.addDelegate(storage)

        let viewController = UniversesViewController()

        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.storage = storage
        viewController.timer = timer

        window.rootViewController = navigationController

        self.window = window
        window.makeKeyAndVisible()
    }
}
