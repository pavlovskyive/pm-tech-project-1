//
//  SolarSystemDetailedState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import GameplayKit.GKState

class SolarSystemDetailedState: GKState {

    var solarSystem: SolarSystem?
    var solarSystemDetailedCoordinator: SolarSystemDetailedCoordinator?

    override func didEnter(from previousState: GKState?) {
        guard let solarSystem = solarSystem,
              let stateMachine = stateMachine as? StateMachine
        else {
            return
        }

        let solarSystemDetailedCoordinator = SolarSystemDetailedCoordinator(
            presenter: stateMachine.presenter,
            solarSystem: solarSystem,
            timer: stateMachine.timer)

        self.solarSystemDetailedCoordinator = solarSystemDetailedCoordinator
        solarSystemDetailedCoordinator.start()

    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}
