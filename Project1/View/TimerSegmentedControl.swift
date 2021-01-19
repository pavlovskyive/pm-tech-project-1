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
        guard let pauseImage = UIImage(systemName: "pause")?
                .withTintColor(.white, renderingMode: .alwaysOriginal),
              let playImage = UIImage(systemName: "play")?
                .withTintColor(.white, renderingMode: .alwaysOriginal),
              let maxSpeedImage = UIImage(systemName: "forward")?
                .withTintColor(.white, renderingMode: .alwaysOriginal)
        else { fatalError("It can't be, can it?") }

        self.init(items: [pauseImage, playImage, maxSpeedImage])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimerSegmentedControl {

    // MARK: - Setup

    func setup() {
        selectedSegmentTintColor = .systemIndigo
        sizeToFit()
        selectedSegmentIndex = 1
    }
}
