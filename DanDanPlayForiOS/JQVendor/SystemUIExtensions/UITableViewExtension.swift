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
    
    public func reloadTableViewWithAnimation(forRow rowNumberInAll: Int, in section: Int, withAnimation animation: UITableView.RowAnimation) {
        var indexPaths: [IndexPath] = []
        if (rowNumberInAll < 1) {fatalError("JQViewExtensions: There must be AT LEAST 1 row")}
        for i in 0...(rowNumberInAll - 1) {indexPaths.append(IndexPath.init(row: i, section: section))}
        self.reloadRows(at: indexPaths, with: animation)
        self.reloadData()
    }
    
}
