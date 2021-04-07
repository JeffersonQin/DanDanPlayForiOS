//
//  UITextViewExtension.swift
//  Snips
//
//  Created by Jefferson Qin on 2019/4/23.
//  Copyright © 2019 Jefferson Qin. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
    
    public func scrollToBack() {
        DispatchQueue.main.async {
            let nsra:NSRange = NSMakeRange((self.text.lengthOfBytes(using: String.Encoding.utf8))-1, 1)
            self.scrollRangeToVisible(nsra)
        }
    }
    
    public func append(_ str: String) {
        DispatchQueue.main.async {
            let attributedString_Origin = self.attributedText
            let attributedString_New: NSMutableAttributedString = NSMutableAttributedString.init(attributedString: attributedString_Origin!)
            attributedString_New.append(NSAttributedString.init(string: str))
            attributedString_New.append(NSAttributedString.init(string: "\n"))
            self.attributedText = NSAttributedString.init(attributedString: attributedString_New)
        }
    }
    
    public func append(_ str: NSAttributedString) {
        DispatchQueue.main.async {
            let attributedString_Origin = self.attributedText
            let attributedString_New: NSMutableAttributedString = NSMutableAttributedString.init(attributedString: attributedString_Origin!)
            attributedString_New.append(str)
            attributedString_New.append(NSAttributedString.init(string: "\n"))
            self.attributedText = NSAttributedString.init(attributedString: attributedString_New)
        }
    }
    
    public func log(_ str: String) {
        self.append(str)
        self.scrollToBack()
    }
    
    public func log(_ str: NSAttributedString) {
        self.append(str)
        self.scrollToBack()
    }
    
}
