//
//  TDNoteEntity.swift
//  SimpleToDo
//
//  Created by MacAir on 02/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import Foundation
import CoreData

class TDNoteEntity: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var creationDate: NSDate
    @NSManaged var remindDate: NSDate
    @NSManaged var id: NSNumber

}
