//
//  UITableViewExtension.swift
//  Snips
//
//  Created by Jefferson Qin on 2019/4/23.
//  Copyright © 2019 Jefferson Qin. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    public func insertAndReloadRowWithAnimation(at indexPath: IndexPath, withAnimation animation: UITableView.RowAnimation) {
        self.insertRows(at: [indexPath], with: animation)
        self.reloadData()
    }
    
    public func deleteAndReloadRowWithAnimation(at indexPath: IndexPath, withAnimation animation: UITableView.RowAnimation) {
        self.deleteRows(at: [indexPath], with: animation)
        self.reloadData()
    }
    
    public func insertAndReloadRowsWithAnimation(at indexPaths: [IndexPath], withAnimation animation: UITableView.RowAnimation) {
        self.insertRows(at: indexPaths, with: animation)
        self.reloadData()
    }
    
    public func deleteAndReloadRowsWithAnimation(at indexPaths: [IndexPath], withAnimation animation: UITableView.RowAnimation) {
        self.deleteRows(at: indexPaths, with: animation)
        self.reloadData()
    }
    
}
