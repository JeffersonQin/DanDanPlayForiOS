//
//  UIntExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/7/25.
//

import Foundation

public extension UInt {
    
    var toInt : Int         {return Int(self)}
    
    var toUInt32 : UInt32   {return UInt32(self)}
    
    static func gcd(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        let remainder = firstNum % secondNum
        if remainder != 0 {
            return gcd(secondNum, remainder)
        } else {
            return secondNum
        }
    }
    
    static func lcm(_ firstNum: UInt, _ secondNum: UInt) -> UInt {
        return firstNum * secondNum / UInt.gcd(firstNum, secondNum)
    }
    
}

extension UInt32 {
    
    var toInt : Int         {return Int(self)}
    
    var toUInt : UInt       {return UInt(self)}
    
}
