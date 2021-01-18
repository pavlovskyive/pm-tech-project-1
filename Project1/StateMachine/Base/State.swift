//
//  State.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 18.01.2021.
//

import Foundation

class State {

    weak var stateMachine: StateMachine?

    func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }

    func willExit(to nextState: State) {}

    func didEnter(from previousState: State?) {}
}
