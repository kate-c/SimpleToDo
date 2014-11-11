//
//  TDChangeNoteView.swift
//  SimpleToDo
//
//  Created by MacAir on 10/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDChangeNoteView: PSXibView {

    @IBOutlet weak var dataPicker: UIDatePicker!
    
    var note: TDNoteEntity?
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: "TDChangeNoteView", andCoder: aDecoder)
    }

    @IBAction func buttonDataPickerChanged(sender: UIDatePicker) {
        note?.creationDate = dataPicker.date
        
        if let temp = note {
            TDDataModel.sharedInstance.changeNoteByDate(dataPicker.date, note: temp)
            let reloadTableView = "reloadTableView"
            NSNotificationCenter.defaultCenter().postNotificationName(reloadTableView, object: nil)
        }
        
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.hidden = true
    }
}
