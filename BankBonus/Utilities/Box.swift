//
//  Box.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 22/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation
import Foundation

class Box<T> {
    
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
