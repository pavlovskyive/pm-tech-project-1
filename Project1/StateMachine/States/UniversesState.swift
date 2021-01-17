//
//  UniversesState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import GameplayKit.GKState

class UniversesState: GKState {

    lazy var universesCoordinator = makeUniversesCoordinator()

    override func didEnter(from previousState: GKState?) {
        if previousState == nil {
            universesCoordinator?.start()
        } else {
            (stateMachine as? StateMachine)?
                .presenter
                .popToRootViewController(animated: true)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == GalaxiesState.self
    }

    private func makeUniversesCoordinator() -> UniversesCoordinator? {
        guard let stateMachine = stateMachine as? StateMachine else {
            return nil
        }

        return UniversesCoordinator(
            presenter: stateMachine.presenter,
            storage: stateMachine.storage,
            timer: stateMachine.timer)
    }
}
