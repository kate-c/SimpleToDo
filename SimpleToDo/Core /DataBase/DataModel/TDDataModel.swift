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
    
    private func maxNoteIdInGroup(group: TDNoteGroupEntity) -> Int {
        return group.maxNoteId.integerValue
    }
    
    func addNote(content: String, toGroup group: TDNoteGroupEntity) -> TDNoteEntity {
        let note = TDNoteEntity.MR_createEntity() as TDNoteEntity
        note.content = content
        note.creationDate = NSDate()
        note.noteId = maxNoteIdInGroup(group) + 1
        
        group.maxNoteId = note.noteId
        group.addNotesObject(note)
        
        context.MR_saveToPersistentStoreAndWait()
        return note
    }
    
    func deleteNoteById(id: Int, inGroup group: TDNoteGroupEntity) {
        var note: TDNoteEntity? = TDNoteEntity.MR_findFirstByAttribute("noteId", withValue: id) as? TDNoteEntity
        
        note?.MR_deleteInContext(context)
        context.MR_saveToPersistentStoreAndWait()
    }

    func findByNoteInfo(info: String) -> [TDNoteEntity] {        
        return TDDataModel.sharedInstance.notes.filter({( note: TDNoteEntity) -> Bool in
            var stringMatch = note.content.rangeOfString(info)
            return stringMatch != nil
        })
    }
    
    func changeNoteByDate(date: NSDate, note: TDNoteEntity) {
        note.creationDate = date
        context.MR_saveToPersistentStoreAndWait()
    }
    
    // MARK: - groups
    var groups: [TDNoteGroupEntity] {
        return (TDNoteGroupEntity.MR_findAllSortedBy("name", ascending: true) as? [TDNoteGroupEntity]) ?? []
    }
    
    private var maxGroupId: Int {
        var maxId: Int = 0
        
        for group in groups {
            if group.noteGroupId.integerValue > maxId {
                maxId = group.noteGroupId.integerValue
            }
        }
        
        return maxId
    }
    
    func addGroup(name: String) -> TDNoteGroupEntity{
        let group = TDNoteGroupEntity.MR_createEntity() as TDNoteGroupEntity
        group.name = name
        group.maxNoteId = -1
        group.noteGroupId = maxGroupId + 1
        
        context.MR_saveToPersistentStoreAndWait()
        return group
    }
    
}
