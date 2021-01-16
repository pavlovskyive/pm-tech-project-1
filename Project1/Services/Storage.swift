//
//  Storage.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import Foundation

protocol StorageProvider {
    func fetchUniverses() -> [Universe]
    func append<T>(_ element: T)
}

class RAMStorge {
    static var shared = RAMStorge()
    
    var universes = [Universe]()
    var galaxies = [Galaxy]()
}

extension RAMStorge: StorageProvider {
    func fetchUniverses() -> [Universe] {
        self.universes
    }
    
    func append<T>(_ element: T) {
        switch element {
        case is Universe:
            universes.append(element as! Universe)
        case is Galaxy:
            galaxies.append(element as! Galaxy)
        default:
            break
        }
    }
}
