//
//  RepeatingTimer.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import Foundation

@objc protocol TimerDelegate {
    func handleTick()
}

class RepeatingTimer {

    var timeInterval: TimeInterval

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    lazy private var timer: DispatchSourceTimer = setTimer()

    var delegates = MulticastDelegate<TimerDelegate>()

    enum State: Int {
        case suspended = 0
        case resumed = 1
        case faster = 2
    }

    private(set) var state: State = .suspended

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
    }

    private func setTimer() -> DispatchSourceTimer {
        let timeSource = DispatchSource.makeTimerSource()
        timeSource.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        timeSource.setEventHandler(handler: { [weak self] in
            self?.timerEvent()
        })
        return timeSource
    }

    func timerEvent() {
        delegates.invoke { $0.handleTick() }
    }

    func addDelegate(_ delegate: TimerDelegate) {
        delegates.add(delegate)
    }

    func resume() {

        switch state {
        case .faster:
            timer.cancel()
            fallthrough
        case .suspended:
            state = .resumed
            timeInterval = 1
            timer = setTimer()
            timer.resume()
        default:
            return
        }
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.cancel()
    }

    func faster() {

        switch state {
        case .resumed:
            timer.cancel()
            fallthrough
        case .suspended:
            state = .faster
            timeInterval = 0.01
            timer = setTimer()
            timer.resume()
        default:
            return
        }
    }
}
