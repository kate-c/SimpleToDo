//
//  StartViewController.swift
//  SimpleToDo
//
//  Created by MacAir on 01/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDStartViewController: UIViewController, UITableViewDataSource, UIAlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notes: [TDNoteEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addNoteButtonAction"))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("deleteLastNoteButtonAction"))
        
        updateData()
    }

    // MARK: - table view data sourse
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        cell.textLabel.text = notes[indexPath.row].content + " \(notes[indexPath.row].noteId)"
        
        return cell
    }

    // MARK: - button action
    func addNoteButtonAction() {
        let alertView = UIAlertView(title: "", message: "Enter note content", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alertView.alertViewStyle = .PlainTextInput
        alertView.show()
    }
    
    func deleteLastNoteButtonAction() {
        TDDataModel.sharedInstance.deleteNoteById(Int(TDDataModel.sharedInstance.notes[notes.count - 1].noteId))
        updateData()
    }
    
    // MARK: - alert view delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let textField = alertView.textFieldAtIndex(0)
        if buttonIndex != 0 {
            TDDataModel.sharedInstance.addNote(textField?.text ?? "")
            updateData()
        }        
    }
    
    func updateData() {
        notes = TDDataModel.sharedInstance.notes
        tableView.reloadData()
    }

}
