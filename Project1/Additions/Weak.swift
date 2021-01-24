//
//  Weak.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 18.01.2021.
//

import Foundation

class Weak<T: AnyObject> {

    weak var value: T?

    init(value: T) {
        self.value = value
    }
}
