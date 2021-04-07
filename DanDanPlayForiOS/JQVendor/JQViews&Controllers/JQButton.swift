//
//  JQButton.swift
//  Snips
//
//  Created by Jefferson Qin on 2019/4/24.
//  Copyright © 2019 Jefferson Qin. All rights reserved.
//

import Foundation
import UIKit

class JQButton: UIButton {
    
    public var storeValues: Dictionary<String, Any>? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(withValues values: Dictionary<String, Any>?, _ frame: CGRect) {
        super.init(frame: frame)
        self.storeValues = values
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
