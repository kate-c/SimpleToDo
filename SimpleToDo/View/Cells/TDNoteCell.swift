//
//  TDDataChangeCell.swift
//  SimpleToDo
//
//  Created by MacAir on 10/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDNoteCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var remindDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillWithNote(note: TDNoteEntity) {
        self.infoLabel.text = note.content
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        self.remindDateLabel.text = dateFormatter.stringFromDate(note.creationDate)
    }
    
    @IBAction func checkButtonAction(sender: UIButton) {
        
    }
    
    
}
