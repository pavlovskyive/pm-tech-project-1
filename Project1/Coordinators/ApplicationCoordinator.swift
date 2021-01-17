//
//  ApplicationCoordinator.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class ApplicationCoordinator: Coordinator {

    let window: UIWindow
    let rootViewController: UINavigationController

    let stateMachine: StateMachine
    let storage: Storage
    let timer: RepeatingTimer

    init(window: UIWindow) {
        self.window = window
        storage = Storage()
        timer = RepeatingTimer(timeInterval: 1)
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true

        stateMachine = StateMachine(
            presenter: rootViewController,
            storage: storage,
            timer: timer,
            states: [
                UniversesState(),
                GalaxiesState(),
                SolarSystemsState(),
                SolarSystemDetailedState()
            ])
    }

    func start() {
        stateMachine.enter(UniversesState.self)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        subscribeToNotifications()
        timer.resume()
    }

    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(receivedUniversesNotification),
            name: Notification.Universes, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(receivedGalaxiesNotification),
            name: Notification.Galaxies, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(receivedSolarSystemsNotification),
            name: Notification.SolarSystems, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(receivedSolarSystemDetailedNotification),
            name: Notification.SolarSystemDetailed, object: nil)
    }

    @objc func receivedUniversesNotification() {
        stateMachine.enter(UniversesState.self)
    }

    @objc func receivedGalaxiesNotification(notification: NSNotification) {
        guard let universe = notification.object as? Universe,
              let galaxiesState = stateMachine.state(forClass: GalaxiesState.self)
        else {
            return
        }

        galaxiesState.universe = universe
        stateMachine.enter(GalaxiesState.self)
    }

    @objc func receivedSolarSystemsNotification(notification: NSNotification) {
        guard let galaxy = notification.object as? Galaxy,
              let solarSystemsState = stateMachine.state(forClass: SolarSystemsState.self)
        else {
            return
        }

        solarSystemsState.galaxy = galaxy
        stateMachine.enter(SolarSystemsState.self)
    }

    @objc func receivedSolarSystemDetailedNotification(notification: NSNotification) {
        guard let solarSystem = notification.object as? SolarSystem,
              let solarSystemDetailedState = stateMachine.state(forClass: SolarSystemDetailedState.self)
        else {
            return
        }

        solarSystemDetailedState.solarSystem = solarSystem
        stateMachine.enter(SolarSystemDetailedState.self)
    }
}
