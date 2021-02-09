//
//  MulticastDelegate.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 24.01.2021.
//

import Foundation

class MulticastDelegate<T> {

    private class DelegateWrapper {

        weak var delegate: AnyObject?

        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }

    private var delegateWrappers: [DelegateWrapper]

    private var delegates: [T] {

        return delegateWrappers.compactMap { delegateWrapper in
            if let delegate = delegateWrapper.delegate as? T {
                return delegate
            }

            return nil
        }
    }

    public init(delegates: [T] = []) {
        delegateWrappers = delegates.map {
            DelegateWrapper($0 as AnyObject)
        }
    }

    public func add(_ delegate: T) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }

    public func remove(_ delegate: T) {
        guard let index = delegateWrappers.firstIndex(where: {
            $0.delegate === (delegate as AnyObject)
        }) else {
            return
        }
        delegateWrappers.remove(at: index)
    }

    public func invoke(_ closure: (T) -> Void) {
        delegates.forEach { closure($0) }
    }
}
