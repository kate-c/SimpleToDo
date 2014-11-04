//
//  TDDataModel.swift
//  SimpleToDo
//
//  Created by MacAir on 02/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

import UIKit

class TDDataModel: NSObject {
    private var context: NSManagedObjectContext!
    
    //MARK: - object creation
    class var sharedInstance : TDDataModel {
        struct Static {
            static let instance : TDDataModel = TDDataModel()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        setupLocalStorage()
    }
    
    private func setupLocalStorage() {
        MagicalRecord.setupCoreDataStackWithStoreNamed("TDNotesModel")
        context = NSManagedObjectContext.MR_defaultContext()
    }
    
    //MARK: - notes
    var notes: [TDNoteEntity] {
        return (TDNoteEntity.MR_findAllSortedBy("creationDate", ascending: true) as? [TDNoteEntity]) ?? []
    }
    
    private var maxNoteId: Int {
        var maxId: Int = 0
        
        for note in notes {
            if note.noteId.integerValue > maxId {
                maxId = note.noteId.integerValue
            }
        }
        
        return maxId
    }
    
    func addNote(content: String) {
        let note = TDNoteEntity.MR_createEntity() as TDNoteEntity
        note.content = content
        note.creationDate = NSDate()
        note.noteId = maxNoteId + 1
        
        context.MR_saveToPersistentStoreAndWait()
    }
    
    func deleteNoteById(id: Int) {
        var note: TDNoteEntity? = TDNoteEntity.MR_findFirstByAttribute("noteId", withValue: id) as? TDNoteEntity
        
        note?.MR_deleteInContext(context)
        context.MR_saveOnlySelfAndWait()
    }

}
