//
//  UIViewControllerExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/7/25.
//

#if os(iOS)

import Foundation
import UIKit

public extension UIViewController {
    
    var ScreenBounds : CGRect               {return UIScreen.main.bounds}
    
    var NavigationFrame : CGRect?           {return self.navigationController?.navigationBar.frame}
    
    var TabbarFrame : CGRect?               {return self.tabBarController?.tabBar.frame}
    
    var StatusBarFrame : CGRect             {return UIApplication.shared.statusBarFrame}
    
    var ScreenWidth : CGFloat               {return self.ScreenBounds.width}
    
    var ScreenHeight : CGFloat              {return self.ScreenBounds.height}
    
    var NavigationWidth : CGFloat?          {return self.NavigationFrame?.width}
    
    var NavigationHeight : CGFloat?         {return self.NavigationFrame?.height}
    
    var TabbarWidth : CGFloat?              {return self.TabbarFrame?.width}
    
    var TabbarHeight : CGFloat?             {return self.TabbarFrame?.height}
    
    var StatusBarWidth : CGFloat            {return self.StatusBarFrame.width}
    
    var StatusBarHeight : CGFloat           {return self.StatusBarFrame.height}
    
    var ScreenBoundsRawSet : [CGFloat]      {return [self.ScreenBounds.minX, self.ScreenBounds.minY, self.ScreenWidth, self.ScreenHeight]}
    
    var NavigatonFrameRawSet : [CGFloat?]   {return [self.NavigationFrame?.minX, self.NavigationFrame?.minY, self.NavigationWidth, self.NavigationHeight]}
    
    var StatusBarFrameRawSet : [CGFloat]    {return [self.StatusBarFrame.minX, self.StatusBarFrame.minY, self.StatusBarWidth, self.StatusBarHeight]}
    
    var TabbarFrameRawSet : [CGFloat?]      {return [self.TabbarFrame?.minX, self.TabbarFrame?.minY, self.TabbarWidth, self.TabbarHeight]}
    
    var ScreenX : CGFloat                   {return self.ScreenBounds.minX}
    
    var ScreenY : CGFloat                   {return self.ScreenBounds.minY}
    
    var NavigationX : CGFloat?              {return self.NavigationFrame?.minX}
    
    var NavigationY : CGFloat?              {return self.NavigationFrame?.minY}
    
    var TabbarX : CGFloat?                  {return self.TabbarFrame?.minX}
    
    var TabbarY : CGFloat?                  {return self.TabbarFrame?.minY}
    
    var StatusBarX : CGFloat                {return self.StatusBarFrame.minX}
    
    var StatusBarY : CGFloat                {return self.StatusBarFrame.minY}
    
}

#endif
