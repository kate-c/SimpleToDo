//
//  TDNoteGroupsViewController.swift
//  SimpleToDo
//
//  Created by MacAir on 10/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDNoteGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var groups: [TDNoteGroupEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = TDDataModel.sharedInstance.groups
        
        let identifier: String = "TDNoteGroupCell";
        self.tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier);
        
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addNoteGroupsButtonAction"))
        
    }
    
    // MARK: - table view delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "TDNoteGroupCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as TDNoteGroupCell
        
        cell.folderNameLabel.text = groups[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let notesVC = TDNotesViewController(nibName: "TDNotesViewController", bundle: nil)
        notesVC.group = groups[indexPath.row]
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
    
    // MARK: - button action
    func addNoteGroupsButtonAction() {
        let alertView = UIAlertView(title: "", message: "Enter folder name", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alertView.alertViewStyle = .PlainTextInput
        alertView.show()
    }
    
    // MARK: - alert view delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let textField = alertView.textFieldAtIndex(0)
        if buttonIndex != 0 {
            let group = TDDataModel.sharedInstance.addGroup(textField?.text ?? "")
            addData([group])
        }
    }
    
    // MARK: - add and remove data
    func addData(addedGroups: [TDNoteGroupEntity]) {
        groups = TDDataModel.sharedInstance.groups
        
        var indexes: [NSIndexPath] = []
        for group in addedGroups {
            if let index = find(groups, group) {
                indexes.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        tableView.insertRowsAtIndexPaths(indexes, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func removeData(arrayOfIndexPathes: [NSIndexPath]) {
        groups = TDDataModel.sharedInstance.groups        
        tableView.deleteRowsAtIndexPaths(arrayOfIndexPathes, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            TDDataModel.sharedInstance.deleteGroupById(Int(groups[indexPath.row].noteGroupId))
            removeData([indexPath])
        }
    }

}
