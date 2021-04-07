//
//  StringExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/8/3.
//

import Foundation

public extension String {
    
    mutating func setUpperCase() {
        self = self.upperCase
    }
    
    var upperCase: String {
        let chars = self.charSet
        var chrs = [Character]()
        for c in chars {
            var i = c.toInt
            if i >= 97 && i <= 122 {
                i -= 32
                chrs.append(i.toChar)
            } else {
                chrs.append(c)
            }
        }
        return charSetToString(set: chrs)
    }
    
    mutating func setDownerCase() {
        self = self.downerCase
    }
    
    var downerCase: String {
        let chars = self.charSet
        var chrs = [Character]()
        for c in chars {
            var i = c.toInt
            if i >= 65 && i <= 90 {
                i += 32
                chrs.append(i.toChar)
            } else {
                chrs.append(c)
            }
        }
        return charSetToString(set: chrs)
    }
    
    func char(at index: Int) -> Character {
        var chars = [Character]()
        for chr in self {
            chars.append(chr)
        }
        return chars[index]
    }
    
    var charSet: [Character] {
        get {
            var chars = [Character]()
            for chr in self {
                chars.append(chr)
            }
            return chars
        }
        set(value) {
            var str: String = ""
            for chr in value {
                str.append(chr)
            }
            self = str
        }
    }
    
    func charSet(till index: Int) -> [Character] {
        var chars = [Character]()
        for i in 0...index {
            chars.append(self.char(at: i))
        }
        return chars
    }
    
    func charSet(from start_Index: Int, to end_Index: Int) -> [Character] {
        var chars = self.charSet(till: end_Index)
        if start_Index == 0 {
        } else if start_Index == 1 {
            chars.remove(at: 0)
        } else {
            for _ in 1...start_Index {
                chars.remove(at: 0)
            }
        }
        return chars
    }
    
    func subString(at index: Int) -> String {
        return self.char(at: index).toString
    }
    
    func subString(till index: Int) -> String {
        return charSetToString(set: charSet(till: index))
    }
    
    func substring(from index_Start: Int, to index_End: Int) -> String {
        return charSetToString(set: charSet(from: index_Start, to: index_End))
    }
    
    func subString(from index: Int, with length: Int) -> String {
        return self.substring(from: index, to: index + length - 1)
    }
    
    func subStringSet(withLength length: Int) -> [String] {
        var strs = [String]()
        for i in 0...self.count - length {
            strs.append(self.subString(from: i, with: length))
        }
        return strs
    }
    
    func match(till index: Int, with string: String) -> Bool {
        let chars = self.charSet(till: index)
        let str = charSetToString(set: chars)
        return str == string ? true : false
    }
    
    func match(from index_Start: Int, to index_End: Int, withString string: String) -> Bool {
        let chars = self.charSet(from: index_Start, to: index_End)
        let str = charSetToString(set: chars)
        return str == string ? true : false
    }
    
    // Note: If string == "", it will return false in case it breaks!!!
    func containsCountinually(_ string: String) -> Bool {
        let selfLength = self.count
        let strLength = string.count
        if string == "" {
            return false
        } else if selfLength < strLength {
            return false
        } else if selfLength == strLength && self == string {
            return true
        } else if selfLength == strLength && self != string {
            return false
        } else {
            let substringset = self.subStringSet(withLength: strLength)
            if substringset.contains(string)    {return true}
            else                                {return false}
        }
    }
    
    // Note: If string == "", it will return false in case it breaks!!!
    func containsContinuouslyIgnoringUpperOrDownerCase(_ string: String) -> Bool {
        return self.downerCase.containsCountinually(string.downerCase)
    }
    
    // Note: If string == "", it will return false in case it breaks!!!
    func containsUnCsontinuously(_ string: String) -> Bool {
        let selfLength = self.count
        let strLength = string.count
        if string == "" {
            return false
        } else if selfLength < strLength {
            return false
        } else if selfLength == strLength && self == string {
            return true
        } else if selfLength == strLength && self != string {
            return false
        } else {
            let selfChars = self.charSet
            var strChars = string.charSet
            for c in selfChars {
                if strChars.count != 0 {
                    if strChars[0] == c {strChars.remove(at: 0)}
                }
            }
            if strChars.count == 0  {return true}
            else                    {return false}
        }
    }
    
    // Note: If string == "", it will return false in case it breaks!!!
    func containsUnContinuouslyIgnoringUpperOrDownerCase(_ string: String) -> Bool {
        return self.downerCase.containsUnCsontinuously(string.downerCase)
    }
    
}

public func charSetToString(set chrs: [Character]) -> String {
    var str = ""
    for chr in chrs {
        str.append(chr.toString)
    }
    return str
}


public extension String {
    
    public func endWithPostfix(_ postfix: String) -> Bool {
        let split = self.split(separator: ".")
        let split_postfix = split[split.count - 1]
        if (split_postfix == postfix) {
            return true
        } else {return false}
    }
    
    public func endWithPostfixs(_ postfixs: [String]) -> Bool {
        let split = self.split(separator: ".")
        let split_postfix = split[split.count - 1]
        var flag = false
        for postfix in postfixs {
            if (postfix == split_postfix) {flag = true}
        }
        return flag
    }
}
