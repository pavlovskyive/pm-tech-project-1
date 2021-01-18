//
//  EventListener.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 18.01.2021.
//

import Foundation

class WeakEventListener<T: AnyObject> {

    weak var value: T?

    init(value: T) {
        self.value = value
    }

    func release() {
        value = nil
    }
}
