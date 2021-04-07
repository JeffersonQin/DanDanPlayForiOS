//
//  UIViewExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/7/25.
//

import Foundation
import UIKit

public extension UIView {
    
    public var Alpha : CGFloat {
        get {
            return self.alpha
        }
        set(value) {
            self.alpha = value
        }
    }
    
    public var Width : CGFloat {
        get {
            return self.frame.width
        }
        set(value) {
            self.frame = CGRect(x: self.xStart, y: self.yStart, width: value, height: self.Height)
        }
    }
    
    public var Height : CGFloat {
        get {
            return self.frame.height
        }
        set(value) {
            self.frame = CGRect(x: self.xStart, y: self.yStart, width: self.Width, height: value)
        }
    }
    
    public var xStart : CGFloat {
        get {
            return self.frame.minX
        }
        set(value) {
            self.frame = CGRect(x: value, y: self.yStart, width: self.Width, height: self.Height)
        }
    }
    
    public var xEnd : CGFloat {
        get {
            return self.frame.maxX
        }
        set(value) {
            self.frame = CGRect(x: value - self.Width, y: self.yStart, width: self.Width, height: self.Height)
        }
    }
    
    public var yStart : CGFloat {
        get {
            return self.frame.minY
        }
        set(value) {
            self.frame = CGRect(x: self.xStart, y: value, width: self.Width, height: self.Height)
        }
    }
    
    public var yEnd : CGFloat {
        get {
            return self.frame.maxY
        }
        set(value) {
            self.frame = CGRect(x: self.xStart, y: value - self.Height, width: self.Width, height: self.Height)
        }
    }
    
    public var Top : CGFloat {
        get {
            return self.frame.minY
        }
        set(value) {
            self.frame = CGRect(x: self.xStart, y: value, width: self.Width, height: self.Height)
        }
    }
    
    public var Bottom : CGFloat {
        get {
            return self.frame.maxY
        }
        set(value) {
            self.frame = CGRect(x: self.xStart, y: value - self.Height, width: self.Width, height: self.Height)
        }
    }
    
    public var Left : CGFloat {
        get {
            return self.frame.minX
        }
        set(value) {
            self.frame = CGRect(x: value, y: self.yStart, width: self.Width, height: self.Height)
        }
    }
    
    public var Right : CGFloat {
        get {
            return self.frame.maxX
        }
        set(value) {
            self.frame = CGRect(x: value - Width, y: self.yStart, width: self.Width, height: self.Height)
        }
    }
    
    public var xCenter : CGFloat {
        get {
            return self.center.x
        }
        set(value) {
            self.center.x = value
        }
    }
    
    public var yCenter : CGFloat {
        get {
            return self.center.y
        }
        set(value) {
            self.center.y = value
        }
    }
    
    public var FrameRawValueSet : [CGFloat]    {
        get {
            return [self.xStart, self.yStart, self.Width, self.Height]
        }
        set(value) {
            self.frame = CGRect(x: value[0], y: value[1], width: value[2], height: value[3])
        }
    }
    
    //EZSwiftExtension
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func removeAllSubViews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    //EZSwiftExtension
    public func centerXinSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        self.xStart = (parentView.Width) / 2 - self.Width / 2
    }
    
    //EZSwiftExtension
    public func centerYinSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        self.yStart = (parentView.Height) / 2 - self.Height / 2
    }
    
    //EZSwiftExtension
    public func CenterViewInSuperView() {
        self.centerXinSuperView()
        self.centerYinSuperView()
    }
    
    public func SameSizeAsSuperView() {
        self.FrameRawValueSet = (self.superview?.FrameRawValueSet)!
    }
    
    public func beInvisibleBySettingAlpha() {
        self.alpha = 0
    }
    
    public func setAlpha(alpha: CGFloat) {
        self.alpha = alpha
    }
    
    public func setWidth(width: CGFloat) {
        self.Width = width
    }
    
    public func setHeight(height: CGFloat) {
        self.Height = height
    }
    
    public func setCenter(center: CGPoint) {
        self.center = center
    }
    
    public func setCenterX(centerX: CGFloat) {
        self.xCenter = centerX
    }
    
    public func setCenterY(centerY: CGFloat) {
        self.yCenter = centerY
    }
    
    public func setOriginalX(originalX: CGFloat) {
        self.xStart = originalX
    }
    
    public func setOriginalY(originalY: CGFloat) {
        self.yStart = originalY
    }
    
    public func setBackGroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    public func setBackGroundColor(color: CGColor) {
        self.backgroundColor = UIColor(cgColor: color)
    }
    
}
