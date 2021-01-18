//
//  StateMachine.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 18.01.2021.
//

import Foundation

class StateMachine {
    private(set) var currentState: State?

    func enter(_ state: State) {

        guard let currentState = currentState else {
            state.stateMachine = self
            self.currentState = state
            self.currentState?.didEnter(from: nil)
            return
        }

        if currentState.isValidNextState(type(of: state)) {

            currentState.willExit(to: state)

            let previousState = currentState
            state.stateMachine = self

            self.currentState = state
            self.currentState?.didEnter(from: previousState)
        }
    }
}
