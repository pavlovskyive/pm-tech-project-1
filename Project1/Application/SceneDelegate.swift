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

        let viewController = UniversesViewController()

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false

        let viewControllerStateMachine = NavigationControllerStateMachine(
            presenter: navigationController,
            storage: storage,
            timer: timer)

        viewController.storage = storage
        viewController.timer = timer
        viewController.stateMachine = viewControllerStateMachine

        timer.addListener(storage)

        viewControllerStateMachine.enter(UniversesState())

        window.rootViewController = navigationController

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
