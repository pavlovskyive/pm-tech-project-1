//
//  TimerSegmentedControl.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

final class TimerSegmentedControl: UISegmentedControl {

    // MARK: - Lifecycle

    override init(items: [Any]?) {
        super.init(items: items)

        setup()
    }

    convenience init() {
        let pauseImage = UIImage(systemName: "pause")!
        let playImage = UIImage(systemName: "play")!
        let maxSpeedImage = UIImage(systemName: "forward")!

        self.init(items: [pauseImage, playImage, maxSpeedImage])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimerSegmentedControl {

    // MARK: - Setup

    func setup() {
        sizeToFit()
        selectedSegmentIndex = 1
    }
}
