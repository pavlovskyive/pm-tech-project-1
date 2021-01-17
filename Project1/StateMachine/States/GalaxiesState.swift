//
//  GalaxiesState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import GameplayKit.GKState

class GalaxiesState: GKState {

    var universe: Universe?
    var galaxiesCoordinator: GalaxiesCoordinator?

    override func didEnter(from previousState: GKState?) {
        guard let universe = universe,
              let stateMachine = stateMachine as? StateMachine
        else {
            return
        }

        let galaxiesCoordinator = GalaxiesCoordinator(
            presenter: stateMachine.presenter,
            universe: universe,
            timer: stateMachine.timer)

        self.galaxiesCoordinator = galaxiesCoordinator
        galaxiesCoordinator.start()

    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == UniversesState.self || stateClass == SolarSystemsState.self
    }
}
