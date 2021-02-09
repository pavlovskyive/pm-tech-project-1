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

    private var timeInterval: TimeInterval

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    lazy private var timer: DispatchSourceTimer = setTimer()

    private var delegates = MulticastDelegate<TimerDelegate>()

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

    private func timerEvent() {
        delegates.invoke { $0.handleTick() }
    }

    public func addDelegate(_ delegate: TimerDelegate) {
        delegates.add(delegate)
    }

    public func removeDelegate(_ delegate: TimerDelegate) {
        delegates.remove(delegate)
    }

    public func resume() {

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

    public func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.cancel()
    }

    public func faster() {

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
