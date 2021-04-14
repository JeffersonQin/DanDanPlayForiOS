//
//  JQDDPSearchTableViewController.swift
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/8.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

import UIKit

class JQDDPSearchTableViewController: UITableViewController, UISearchBarDelegate {

    var libFile: [DDPLinkFile]?
    var rawFile: [DDPLibrary]?
    
    var dataSource: [DDPLibrary]?
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.showsCancelButton = false
        self.searchBar.becomeFirstResponder()
        self.searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        DDPLinkNetManagerOperation.linkGetVideoSubtitleInfo(JQDDPLinkTransmitter.getLinkInfo()?.selectedIpAdress, videoID: "f19b5806-39ea-41f6-ad5e-f20a2e2a9f18") { (res, error) in
//            print(res)
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource?.count ?? 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dataSource = []
        for rf in rawFile! {
            if rf.animeTitle.containsUnContinuouslyIgnoringUpperOrLowerCasesAndSpaces(searchBar.text ?? "") ||
                rf.episodeTitle.containsUnContinuouslyIgnoringUpperOrLowerCasesAndSpaces(searchBar.text ?? "") ||
                rf.name.containsUnContinuouslyIgnoringUpperOrLowerCasesAndSpaces(searchBar.text ?? "") {
                self.dataSource?.append(rf)
            }
        }
        self.searchBar.endEditing(true)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel!.text = dataSource![indexPath.row].name
        cell.detailTextLabel!.text =
            "\(String(describing: dataSource![indexPath.row].animeTitle!)), \(String(describing: dataSource![indexPath.row].episodeTitle!))\n时长: \(dataSource![indexPath.row].duration), 大小: \(dataSource![indexPath.row].size)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.sizeToFit()
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.sizeToFit()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource != nil && libFile != nil {
            let rawInfo = dataSource![indexPath.row]
            for lf in libFile! {
                if lf.name == rawInfo.animeTitle {
                    let sec_libFile = lf.subFiles as! [DDPLinkFile]
                    for sec_lf in sec_libFile {
                        if sec_lf.library.path == rawInfo.path {
                            DDPMethod.match(sec_lf.videoModel, completion: nil)
                        }
                    }
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
