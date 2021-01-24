//
//  MulticastDelegate.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 24.01.2021.
//

import Foundation

class MulticastDelegate<T> {

    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects.reversed()
        where delegate === delegateToRemove as AnyObject {
            delegates.remove(delegate)
        }
    }

    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            guard let delegate = delegate as? T else {
                return
            }
            invocation(delegate)
        }
    }
}
