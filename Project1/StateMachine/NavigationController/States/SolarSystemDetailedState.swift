//
//  SolarSystemDetailedState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import GameplayKit.GKState

class SolarSystemDetailedState: State {

    var solarSystem: SolarSystem?

    override func didEnter(from previousState: State?) {
        guard let stateMachine = stateMachine as? NavigationControllerStateMachine else {
            return
        }

        let solarSystemDetailedViewController = SolarSystemDetailedViewController()
        solarSystemDetailedViewController.solarSystem = solarSystem
        solarSystemDetailedViewController.timer = stateMachine.timer
        solarSystemDetailedViewController.stateMachine = stateMachine

        stateMachine.presenter.pushViewController(solarSystemDetailedViewController, animated: true)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is UniversesState.Type,
             is GalaxiesState.Type,
             is SolarSystemsState.Type:
            return true
        default:
            return false
        }
    }
}
