//
//  NSObject+extension.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import UIKit

protocol Newable { init() }

extension NSObject: Newable {}

extension Newable where Self: NSObject {
    static func new(_ function: (Self) -> Void) -> Self {
        let instance = self.init()
        function(instance)
        return instance
    }
}

extension Newable where Self: UIButton {
    static func new(_ type: UIButton.ButtonType, _ function: (Self) -> Void) -> Self {
        let instance = self.init(type: type)
        function(instance)
        return instance
    }
}

