//
//  SolarSystemsState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

final class SolarSystemsState: State {

    var galaxy: Galaxy?

    override func didEnter(from previousState: State?) {
        guard let stateMachine = stateMachine as? NavigationControllerStateMachine else {
            return
        }

        let solarSystemsViewController = SolarSystemsViewController()
        solarSystemsViewController.galaxy = galaxy
        solarSystemsViewController.timer = stateMachine.timer
        solarSystemsViewController.stateMachine = stateMachine

        switch previousState {
        case is GalaxiesState?:
            stateMachine.presenter.pushViewController(solarSystemsViewController, animated: true)
        default:
            stateMachine.presenter.reveal(solarSystemsViewController)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is UniversesState.Type,
             is GalaxiesState.Type,
             is SolarSystemDetailedState.Type:
            return true
        default:
            return false
        }
    }
}
