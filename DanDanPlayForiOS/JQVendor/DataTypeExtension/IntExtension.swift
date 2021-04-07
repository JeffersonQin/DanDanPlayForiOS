//
//  IntExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/7/25.
//

import Foundation
import UIKit

public extension Int {
    
    var isEven : Bool                                            {return self % 2 == 0}
    
    var isOdd : Bool                                             {return self % 2 == 1}
    
    var isPositive : Bool                                        {return self > 0}
    
    var isNegetive : Bool                                        {return self < 0}
    
    var toTimeInterval: TimeInterval                             {return TimeInterval(self)}
    
    var toFloat : Float                                          {return Float.init(self)}
    
    var toCGFloat : CGFloat                                      {return CGFloat.init(self)}
    
    var toDouble : Double                                        {return Double.init(self)}
    
    var toInt32 : Int32                                          {return Int32.init(self)}
    
    var toString : String                                        {return String(self)}
    
    var toUInt : UInt                                            {return UInt.init(self)}
    
    var toUInt32 : UInt32                                        {return UInt32.init(self)}
    
    var toChar : Character                                       {return Character.init(UnicodeScalar.init(self)!)}
    
    var randomNumber_Included : Int                              {return Int(arc4random_uniform(self.toUInt32)) + 1}
    
    var randomNumber_Unincluded : Int                            {return Int(arc4random_uniform(self.toUInt32))}
    
    var toCountableRange_0_Unincluded : CountableRange<Int>      {return 0 ..< self}
    
    var toCountableRange_1_Included : CountableRange<Int>        {return 1 ..< self + 1}
    
    var digit : Int {
        if self == 0                                                    {return 1}
        else if self <= LONG_MAX                                        {return Int(log10(Double(fabs(self.toDouble)))) + 1}
        else                                                            {return -1}
    }
    
    public var digitArray : [Int?] {
        var arr = [Int?]()
        for char in self.toString {
            arr.append(Int(String(char)))
        }
        return arr
    }
    
    public static func gcd(_ firstNum: Int, _ secondNum: Int) -> Int {
        let k = firstNum * secondNum >= 0 ? 1 : -1
        let remainder = firstNum % secondNum
        if remainder != 0 {
            return self.gcd(secondNum, remainder) * k
        } else {
            return secondNum * k
        }
    }
    
    public static func lcm(_ firstNum: Int, _ secondNum: Int) -> Int {
        return firstNum * secondNum / Int.gcd(firstNum, secondNum)
    }
    
}
