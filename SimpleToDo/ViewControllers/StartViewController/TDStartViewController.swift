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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("deleteLastNoteButtonAction"))
        
        updateData()
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
    
    // MARK: - filter options
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredNotes = notes.filter({( note: TDNoteEntity) -> Bool in
            var stringMatch = note.content.rangeOfString(searchText)
            return stringMatch != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Detail", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "Detail" {
            let noteDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = filteredNotes[indexPath.row].content
                noteDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = notes[indexPath.row].content
                noteDetailViewController.title = destinationTitle
            }
        }
    }

}
