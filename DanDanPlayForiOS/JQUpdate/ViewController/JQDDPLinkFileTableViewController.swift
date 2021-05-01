//
//  JQDDPLinkFileTableViewController.swift
//  DDPlay
//
//  Created by JeffersonQin on 2021/4/7.
//  Copyright © 2021 JeffersonQin. All rights reserved.
//

import UIKit

class JQDDPLinkFileTableViewController: UITableViewController {
    
    private var libFile: [DDPLinkFile]?
    private var rawFile: [DDPLibrary]?
    
    enum JQDDPTableViewCellDisplayMode {
        case reuse
        case automatic
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.tableView.rowHeight = 135
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 12.0, *) {
            LocalNetworkPermissionService.init().triggerDialog()
        } else {
            // Fallback on earlier versions
        }
        
        let hud = MBProgressHUD.showAdded(to: self.tableView, animated: true)
        
        hud.label.text = "资源库加载中..."
        
        if let ipAddress = JQDDPLinkTransmitter.getLinkInfo().selectedIpAdress {
            DDPLinkNetManagerOperation.linkLibrary(withIpAdress: ipAddress) { (raw_collection, raw_part_error) in
                let _root_lib = DDPLibrary.init()
                _root_lib.fileType = .folder
                _root_lib.path = "/"
                let _root_file = DDPLinkFile.init(libraryFile: _root_lib)
                self.rawFile = raw_collection?.collection as? [DDPLibrary] ?? []
                for rf in self.rawFile! {
                    if rf.animeTitle == nil || rf.animeTitle == "" {
                        rf.animeTitle = "未分类"
                    }
                    if rf.episodeTitle == nil || rf.animeTitle == "" {
                        rf.episodeTitle = "识别失败"
                    }
                }
                JQDDPLinkTransmitter.getToolsManager().startDiscovererFile(withLinkParentFile: _root_file, completion: { (libFile, lib_part_error) in
                    self.libFile = libFile?.subFiles as? [DDPLinkFile]
                    self.tableView.reloadData()
                    hud.hide(animated: true)
                    if raw_part_error != nil || lib_part_error != nil {
                        hud.label.text = "Error!"
                        hud.detailsLabel.text = "Raw Error: " + (raw_part_error != nil ? raw_part_error.debugDescription : "") + "\n"
                        hud.detailsLabel.text! += "Lib Error: " + (lib_part_error != nil ? lib_part_error.debugDescription : "")
                        hud.hide(animated: true, afterDelay: TimeInterval.init(2))
                    }
                })
            }
        } else {
            print("error when obtaining ip address")
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
        return self.rawFile?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.init()
        guard rawFile != nil else {return cell}
        
        let mode = JQDDPTableViewCellDisplayMode.automatic
        switch mode {
        case .reuse:
            cell = tableView.dequeueReusableCell(withIdentifier: "fileInfoCell", for: indexPath)
            let fileNameLabel = cell.contentView.viewWithTag(1) as! UITextView
            let episodeLabel = cell.contentView.viewWithTag(2) as! UITextView
            let informationLabel = cell.contentView.viewWithTag(3) as! UITextView
            fileNameLabel.text = rawFile![indexPath.row].name
            episodeLabel.text = "\(String(describing: rawFile![indexPath.row].animeTitle ?? "")), \(String(describing: rawFile![indexPath.row].episodeTitle ?? ""))"
            informationLabel.text = "时长: \(rawFile![indexPath.row].duration), 大小: \(rawFile![indexPath.row].size)"
        case .automatic:
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel!.text = rawFile![indexPath.row].name
            cell.detailTextLabel!.text =
                "\(String(describing: rawFile![indexPath.row].animeTitle!)), \(String(describing: rawFile![indexPath.row].episodeTitle!))\n时长: \(rawFile![indexPath.row].duration), 大小: \(rawFile![indexPath.row].size)"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.sizeToFit()
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            cell.detailTextLabel?.sizeToFit()
        default:
            print("default")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rawFile != nil && libFile != nil {
            let rawInfo = rawFile![indexPath.row]
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "searchSegue" {
            let dstVC = segue.destination as! JQDDPSearchTableViewController
            dstVC.libFile = libFile ?? []
            dstVC.rawFile = rawFile ?? []
        }
    }

}
