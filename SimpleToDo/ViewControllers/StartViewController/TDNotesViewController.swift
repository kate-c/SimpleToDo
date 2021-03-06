//
//  StartViewController.swift
//  SimpleToDo
//
//  Created by MacAir on 01/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDNotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, TDChangeNoteViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeNoteView: TDChangeNoteView!
    
    var notes: [TDNoteEntity] = []
    var filteredNotes: [TDNoteEntity] = []
    var group: TDNoteGroupEntity!
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addNoteButtonAction"))
        
        self.reloadTableView()
        
        let reloadTableView = "reloadTableView"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView", name: reloadTableView, object: nil)
        
        let identifier: String = "TDNoteCell";
        self.tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier);
        
        self.changeNoteView.delegate = self
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
        var tempNote : TDNoteEntity
       
        if tableView == self.searchDisplayController!.searchResultsTableView {
            tempNote = filteredNotes[indexPath.row]
        } else {
            tempNote = notes[indexPath.row]
        }
        
        if tempNote.remindDate == nil {
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
            cell.textLabel.text = tempNote.content
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            
            cell.detailTextLabel?.text = "id: \(tempNote.noteId)" + " creation date: \(dateFormatter.stringFromDate(tempNote.creationDate))"
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            return cell
        }
        
        let identifier = "TDNoteCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as TDNoteCell
        cell.fillWithNote(tempNote)
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
            let note = TDDataModel.sharedInstance.addNote(textField?.text ?? "", toGroup: group)
            addData([note])
        }        
    }
    
    // MARK: - Add or delete updatind
    func addData(addedNotes: [TDNoteEntity]) {
        notes = TDDataModel.sharedInstance.notesInGroup(group)
        
        var indexes: [NSIndexPath] = []
        for note in addedNotes {
            if let index = find(notes, note) {
                indexes.append(NSIndexPath(forRow: index, inSection: 0))
            }
        }
        
        tableView.insertRowsAtIndexPaths(indexes, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func removeData(arrayOfIndexPathes: [NSIndexPath]) {
        notes = TDDataModel.sharedInstance.notesInGroup(group)
        tableView.deleteRowsAtIndexPaths(arrayOfIndexPathes, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // MARK: - filter options
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        filteredNotes = TDDataModel.sharedInstance.findByNoteInfo(searchString, inGroup: group)
        return true
    }
    
    // MARK: - show cell info
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        changeNoteView.hidden = false
        selectedIndexPath = indexPath
        
    }
    
    // MARK - delete cell by swipe
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            TDDataModel.sharedInstance.deleteNoteById(Int(notes[indexPath.row].noteId), inGroup: group)
            removeData([indexPath])
        }
    }
    
    // MARK: - for NSNotificationCenter
    func reloadTableView() {
        notes = TDDataModel.sharedInstance.notesInGroup(group)
        tableView.reloadData()
    }
    
    // MARK: - change note delegate
    func noteView(noteView: TDChangeNoteView, changedValueToDate date: NSDate) {
        var tempNote : TDNoteEntity
        if var indexPath = selectedIndexPath {
            if tableView == self.searchDisplayController!.searchResultsTableView {
                tempNote = filteredNotes[indexPath.row]
            } else {
                tempNote = notes[indexPath.row]
            }
            
            TDDataModel.sharedInstance.changeNoteByDate(date, note: tempNote)
            selectedIndexPath = TDDataModel.sharedInstance.getIndexPath(tempNote, group: group)
            reloadTableView()
        }
    }

}
