//
//  TDNoteGroupEntity.swift
//  SimpleToDo
//
//  Created by MacAir on 02/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import Foundation
import CoreData

class TDNoteGroupEntity: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var source: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var maxNoteId: NSNumber
    @NSManaged var notes: NSSet

}
