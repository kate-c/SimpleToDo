//
//  TDChangeNoteView.swift
//  SimpleToDo
//
//  Created by MacAir on 10/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

protocol TDChangeNoteViewDelegate {
    func noteView(noteView: TDChangeNoteView, changedValueToDate date: NSDate)
}

class TDChangeNoteView: PSXibView {

    @IBOutlet weak var dataPicker: UIDatePicker!
    
    var delegate: TDChangeNoteViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(nibName: "TDChangeNoteView", andCoder: aDecoder)
    }

    @IBAction func buttonDataPickerChanged(sender: UIDatePicker) {
        delegate?.noteView(self, changedValueToDate: dataPicker.date)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.hidden = true
    }
}
