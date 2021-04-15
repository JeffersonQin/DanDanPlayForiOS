//
//  JQDDPLinkSubtitleManagerPickerViewController.swift
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/15.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

import UIKit

class JQDDPLinkSubtitleManagerPickerViewController: UITableViewController {

    @objc public var videoID: String = ""
    private var dataSource: [DDPSubtitle] = []
    @objc public var selectedFileAction: ((DDPFile) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableView.automaticDimension
        let hud = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        hud.label.text = "字幕库加载中..."
        
        if let ipAddress = JQDDPLinkTransmitter.getLinkInfo()?.selectedIpAdress {
            DDPLinkNetManagerOperation.linkGetVideoSubtitleInfo(ipAddress, videoID: videoID) { (subtitle_collection: DDPSubtitleCollection?, error) in
                if error != nil {
                    hud.label.text = "Error!"
                    hud.detailsLabel.text = error.debugDescription
                    hud.hide(animated: true, afterDelay: TimeInterval.init(2))
                } else {
                    self.dataSource = subtitle_collection?.collection as? [DDPSubtitle] ?? []
                    self.tableView.reloadData()
                    hud.hide(animated: true)
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel!.text = self.dataSource[indexPath.row].fileName
        cell.detailTextLabel!.text = "大小: \(self.dataSource[indexPath.row].fileSize)"
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.detailTextLabel!.sizeToFit()
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel!.lineBreakMode = .byWordWrapping
        cell.detailTextLabel!.sizeToFit()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.selectedFileAction!(DDPFile.init(fileURL: ddp_linkSubtitleURL(JQDDPLinkTransmitter.getLinkInfo()?.selectedIpAdress, self.videoID, self.dataSource[indexPath.row].fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)), type: .document))
        self.navigationController?.popToRootViewController(animated: true)
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
