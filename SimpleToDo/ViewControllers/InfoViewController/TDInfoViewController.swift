//
//  TDInfoViewController.swift
//  SimpleToDo
//
//  Created by MacAir on 06/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDInfoViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var note: TDNoteEntity?
    //var rowOfIndexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = note?.content {
            label.text = text
        }
    }
    
    @IBAction func datePickerChange(sender: UIDatePicker) {
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "dd-MM-yyyy 'at' HH:mm"
        
        var strDate = timeFormatter.stringFromDate(datePicker.date)
        
        label.text = "Now is " + strDate;
        
        note?.creationDate = datePicker.date
        
        if let temp = note {
            TDDataModel.sharedInstance.changeNoteByDate(datePicker.date, note: temp)
            let reloadTableView = "reloadTableView"
            NSNotificationCenter.defaultCenter().postNotificationName(reloadTableView, object: nil)
        }
    }
}
