//
//  SolarSystemsState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import GameplayKit.GKState

class SolarSystemsState: GKState {

    var galaxy: Galaxy?
    var solarSystemsCoordinator: SolarSystemsCoordinator?

    override func didEnter(from previousState: GKState?) {
        guard let galaxy = galaxy,
              let stateMachine = stateMachine as? StateMachine
        else {
            return
        }

        let solarSystemsCoordinator = SolarSystemsCoordinator(
            presenter: stateMachine.presenter,
            galaxy: galaxy,
            timer: stateMachine.timer)

        self.solarSystemsCoordinator = solarSystemsCoordinator
        solarSystemsCoordinator.start()

    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == SolarSystemDetailedState.self || stateClass == GalaxiesState.self
    }
}
