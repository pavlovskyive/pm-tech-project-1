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
        /*
         Mentor's comment:
         I was debugging the app to find some bugs and found a following issue. Take a look on the console
         output:
         (lldb) po delegates.allObjects.reversed()
         ▿ ReversedCollection<Array<AnyObject>>
           ▿ _base : 5 elements
             ▿ 0 : <Project1.SolarSystemDetailedViewController: 0x7f9dab91b820>
             ▿ 1 : <Project1.UniversesViewController: 0x7f9dab9096b0>
             ▿ 2 : <Storage: 0x600001180d00>
             ▿ 3 : <Project1.GalaxyViewController: 0x7f9da9c2d6b0>
             ▿ 4 : <Project1.GalaxiesViewController: 0x7f9da9f14ad0>
         
         The code below calls delegates in a sequential order, and the general logic of data reload
         is built around an idea of the datasource (Storage) being updated first, and the UI
         (any UIViewController that extends BasicViewController) next.
         However the console's output tells us that some screens will not reload any data because
         they are called before the storage. Of course eventually they will be called on the next tick,
         so perhaps a user wouldn't notice anything so this isn't a crictical issue, rather an architectural one.
         
         I see two ways of dealing with this issue:
         1. Slightly change the code to ensure the correct order. It's great that you've searched for a suitable
         data structure (NSHashTable) 👍👍👍, however there are no info about whether the data structure maintain order of elements.
         I suggest writing an own wrapper around any structure that allows weak references, so the wrapper adds only
         functionality of stack (LIFO principle) to ensure the order of handling timer ticks.
         2. Change the architecture and make models notify their controllers (of course via delegates/closures) to ensure
         direct call-to-update data whenever the data changes.
         
         Nice job nevertheless 🙂👍.
         */
        for delegate in delegates.allObjects.reversed() {
            guard let delegate = delegate as? T else {
                return
            }
            invocation(delegate)
        }
    }
}
