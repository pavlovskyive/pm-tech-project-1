//
//  Notifications.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import Foundation

enum Notification {
    static let Universes = NSNotification.Name("UniversesNotification")
    static let Galaxies = NSNotification.Name("GalaxiesNotification")
    static let SolarSystems = NSNotification.Name("SolarSystemsNotification")
    static let SolarSystemDetailed = NSNotification.Name("SolarSystemDetailedNotification")
    static let TimerTick = NSNotification.Name("TimerTickNotification")
}
