//
//  JQSearchBar.swift
//  Snips
//
//  Created by Jefferson Qin on 2019/4/24.
//  Copyright © 2019 Jefferson Qin. All rights reserved.
//

import UIKit

class JQSearchBar: UISearchBar, UISearchBarDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public var searchOption: SearchOption = .searchUncontinuously_ignoreUpperDownerCase
    
    /*
     Returns the searching status
     */
    public var isSearching = false
    
    /*
     This is a three-dimensional array, the first dimension is used for section,
     every array([[String]]) in searchData([[[String]]]), contains the data for each section,
     numbered as: 0, 1, 2, ...
     The array inside the [[String]], which is [String], is used for each row
     The [String] array contains all the data for each row (There may be a lot of String for you to search)
     */
    public var searchData: [[[String]]] = []
    
    /*
     JQSearchBar is a class extended from UISearchBar, it follows the protocal: UISeachBarDelegate
     It is specially extended for UITableView, so that the returnIndexs here is an array of the
     IndexPaths which row matches with the search information
     */
    public var returnIndexs: [IndexPath] = []
    
    /*
     In this closure, you have to implement a function everytime after
     the search begin or end
     */
    public var searchArrangementHandler: ((JQSearchBar) -> Void)? = nil
    
    /*
     In this closure, you have to implement a function everytime after the search ends,
     including the beginning and the endding of the search
     something you need to implement for example: tableView.reloadData()
     */
    public var searchCompletionHandler: ((JQSearchBar) -> Void)? = nil
    
    public init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }

    public init(withSearchData data: [[[String]]], withOption option: JQSearchBar.SearchOption?, withFrame frame: CGRect, withArrangementHandler arrangementHandler: ((JQSearchBar) -> Void)?, withCompletionHandler completion: ((JQSearchBar) -> Void)?) {
        super.init(frame: frame)
        self.searchData = data
        self.searchOption = option ?? .searchUncontinuously_ignoreUpperDownerCase
        self.searchArrangementHandler = arrangementHandler
        self.searchCompletionHandler = completion
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.setShowsCancelButton(false, animated: true)
        isSearching = false
        (searchArrangementHandler ?? {_ in})(self)
        returnIndexs = []
        (searchCompletionHandler ?? {_ in})(self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.setShowsCancelButton(true, animated: true)
        isSearching = true
        (searchArrangementHandler ?? {_ in})(self)
        returnIndexs = []
        (searchCompletionHandler ?? {_ in})(self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
        self.setShowsCancelButton(false, animated: true)
        isSearching = false
        (searchArrangementHandler ?? {_ in})(self)
        returnIndexs = []
        (searchCompletionHandler ?? {_ in})(self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.returnIndexs = []
            for i in searchData.indices {
                for j in searchData[i].indices {
                    self.returnIndexs.append(IndexPath.init(row: j, section: i))
                }
            }
        } else {
            self.returnIndexs = []
            for i in searchData.indices {
                for j in searchData[i].indices {
                    var flag = false
                    for dataString in searchData[i][j] {
                        switch searchOption {
                        case .searchContinuously:
                            if dataString.containsCountinually(searchText) {flag = true}
                        case .searchUncontinuously:
                            if dataString.containsUnCsontinuously(searchText) {flag = true}
                        case .searchContinuously_ignoreUpperDownerCase:
                            if dataString.containsContinuouslyIgnoringUpperOrDownerCase(searchText) {flag = true}
                        case .searchUncontinuously_ignoreUpperDownerCase:
                            if dataString.containsUnContinuouslyIgnoringUpperOrDownerCase(searchText) {flag = true}
                        }
                    }
                    flag ? (self.returnIndexs.append(IndexPath.init(row: j, section: i))) : ()
                }
            }
        }
        (searchCompletionHandler ?? {_ in})(self)
    }
    
}

extension JQSearchBar {
    
    enum SearchOption {
        case searchContinuously
        case searchContinuously_ignoreUpperDownerCase
        case searchUncontinuously
        case searchUncontinuously_ignoreUpperDownerCase
    }
    
}
