//
//  GalaxiesState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import Foundation

class GalaxiesState: State {

    var universe: Universe?

    override func didEnter(from previousState: State?) {

        guard let stateMachine = stateMachine as? NavigationControllerStateMachine else {
            return
        }

        let galaxiesViewController = GalaxiesViewController()
        galaxiesViewController.universe = universe
        galaxiesViewController.timer = stateMachine.timer
        galaxiesViewController.stateMachine = stateMachine

        stateMachine.presenter.pushViewController(galaxiesViewController, animated: true)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == UniversesState.self || stateClass == SolarSystemsState.self
    }
}
