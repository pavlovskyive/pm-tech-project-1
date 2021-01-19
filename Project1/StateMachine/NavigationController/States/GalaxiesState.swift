//
//  GalaxiesState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

final class GalaxiesState: State {

    var universe: Universe?

    override func didEnter(from previousState: State?) {

        guard let stateMachine = stateMachine as? NavigationControllerStateMachine else {
            return
        }

        let galaxiesViewController = GalaxiesViewController()
        galaxiesViewController.universe = universe
        galaxiesViewController.timer = stateMachine.timer
        galaxiesViewController.stateMachine = stateMachine

        switch previousState {
        case is UniversesState?:
            stateMachine.presenter.pushViewController(galaxiesViewController, animated: true)
        default:
            stateMachine.presenter.reveal(galaxiesViewController)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == UniversesState.self || stateClass == SolarSystemsState.self
    }
}
