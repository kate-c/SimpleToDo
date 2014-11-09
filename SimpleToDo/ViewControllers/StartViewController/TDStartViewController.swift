//
//  StartViewController.swift
//  SimpleToDo
//
//  Created by MacAir on 01/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDStartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notes: [TDNoteEntity] = []
    var filteredNotes: [TDNoteEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addNoteButtonAction"))
        
        self.reloadTableView()
        
        let reloadTableView = "reloadTableView"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView", name: reloadTableView, object: nil)
    }

    // MARK: - table view data sourse
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredNotes.count
        } else {
            return notes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        
        var tempNote : TDNoteEntity
       
        if tableView == self.searchDisplayController!.searchResultsTableView {
            tempNote = filteredNotes[indexPath.row]
        } else {
            tempNote = notes[indexPath.row]
        }
        
        cell.textLabel.text = tempNote.content
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        cell.detailTextLabel?.text = "id: \(tempNote.noteId)" + " creation date: \(dateFormatter.stringFromDate(tempNote.creationDate))"
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    // MARK: - button action
    func addNoteButtonAction() {
        let alertView = UIAlertView(title: "", message: "Enter note content", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alertView.alertViewStyle = .PlainTextInput
        alertView.show()
    }
    
    // MARK: - alert view delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let textField = alertView.textFieldAtIndex(0)
        if buttonIndex != 0 {
            let note = TDDataModel.sharedInstance.addNote(textField?.text ?? "")
            addData([note])
        }        
    }
    
    // MARK: - Add or delete updatind
    func addData(addedNotes: [TDNoteEntity]) {
        notes = TDDataModel.sharedInstance.notes
        
        var indexes: [NSIndexPath] = []
        for note in addedNotes {
            if let index = find(notes, note) {
                indexes.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        tableView.insertRowsAtIndexPaths(indexes, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func removeData(arrayOfIndexPathes: [NSIndexPath]) {
        notes = TDDataModel.sharedInstance.notes
        tableView.deleteRowsAtIndexPaths(arrayOfIndexPathes, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // MARK: - filter options
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        filteredNotes = TDDataModel.sharedInstance.findByNoteInfo(searchString)
        return true
    }
    
    // MARK: - show cell info
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let infoVC = TDInfoViewController(nibName: "TDInfoViewController", bundle: nil)
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            infoVC.note = filteredNotes[indexPath.row]
        } else {
            infoVC.note = notes[indexPath.row]
        }
        
        infoVC.view.backgroundColor = UIColor.yellowColor()
        self.navigationController?.pushViewController(infoVC, animated: true)
        
    }
    
    // MARK - delete cell by swipe
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            TDDataModel.sharedInstance.deleteNoteById(Int(notes[indexPath.row].noteId))
            removeData([indexPath])
        }
    }
    
    // MARK: - for NSNotificationCenter
    func reloadTableView() {
        notes = TDDataModel.sharedInstance.notes
        tableView.reloadData()
    }

}
