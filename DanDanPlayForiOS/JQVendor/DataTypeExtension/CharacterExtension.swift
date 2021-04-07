//
//  CharacterExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/8/3.
//

import Foundation

public extension Character {
    
    var toString: String {
        return String(self)
    }
    
    var toInt: Int {
        var r = 0
        for scalar in self.unicodeScalars {
            r = scalar.value.toInt
        }
        return r
    }
    
}
