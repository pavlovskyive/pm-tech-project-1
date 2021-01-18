//
//  UniversesState.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class UniversesState: State {

    override func didEnter(from previousState: State?) {
        (stateMachine as? NavigationControllerStateMachine)?.presenter
            .popToRootViewController(animated: true)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == GalaxiesState.self
    }
}
