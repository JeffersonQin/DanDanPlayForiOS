//
//  JQViews.swift
//  H-Downloader
//
//  Created by Jefferson Qin on 2019/4/8.
//  Copyright © 2019 Jefferson Qin. All rights reserved.
//

import Foundation
import UIKit

class JQAlertViewControl {

    public static func showMessage(in viewController: UIViewController, for time: TimeInterval, with title: String, with subTitle: String, endWith completion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: title, message: subTitle, preferredStyle: .alert)
            viewController.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(time)) {
                alertController.dismiss(animated: true, completion: completion)
            }
        }
    }
    
    public static func showMessageAlert(in viewController: UIViewController, for time: TimeInterval, with title: String, with subTitle: String, endWith completion: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController.init(title: title, message: subTitle, preferredStyle: .alert)
            let OKAction = UIAlertAction.init(title: "OK", style: .default, handler: completion)
            alertController.addAction(OKAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
}
