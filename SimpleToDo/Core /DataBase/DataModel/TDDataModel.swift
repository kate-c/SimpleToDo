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
    func notesInGroup(group: TDNoteGroupEntity) -> [TDNoteEntity] {
        let predicate = NSPredicate(format: "group = %@", group)
        let notes = TDNoteEntity.MR_findAllSortedBy("creationDate", ascending: true, withPredicate: predicate)
        println(notes)
        return (notes as? [TDNoteEntity]) ?? []
    }
    
    private func maxNoteIdInGroup(group: TDNoteGroupEntity) -> Int {
        return group.maxNoteId.integerValue
    }
    
    func addNote(content: String, toGroup group: TDNoteGroupEntity) -> TDNoteEntity {
        let note = TDNoteEntity.MR_createEntity() as TDNoteEntity
        note.content = content
        note.creationDate = NSDate()
        note.noteId = maxNoteIdInGroup(group) + 1
        note.group = group
        
        group.maxNoteId = note.noteId
        group.addNotesObject(note)
        
        context.MR_saveToPersistentStoreAndWait()
        return note
    }
    
    func deleteNoteById(id: Int, inGroup group: TDNoteGroupEntity) {
        var note: TDNoteEntity? = TDNoteEntity.MR_findFirstWithPredicate(NSPredicate(format: "(group = %@) AND (noteId = %i)", group, id)) as? TDNoteEntity
        
        note?.MR_deleteInContext(context)
        context.MR_saveToPersistentStoreAndWait()
    }

    func findByNoteInfo(var info: String, inGroup: TDNoteGroupEntity) -> [TDNoteEntity] {
        info = info.lowercaseString
        return TDDataModel.sharedInstance.notesInGroup(inGroup).filter({( note: TDNoteEntity) -> Bool in
            var stringMatch = note.content.lowercaseString.rangeOfString(info)
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
        group.maxNoteId = 0
        group.noteGroupId = maxGroupId + 1
        
        context.MR_saveToPersistentStoreAndWait()
        return group
    }
    
    func deleteGroupById(id: Int) {
        var group: TDNoteGroupEntity? = TDNoteGroupEntity.MR_findFirstWithPredicate(NSPredicate(format: "(noteGroupId = %i)", id)) as? TDNoteGroupEntity
        
        group?.MR_deleteInContext(context)
        context.MR_saveToPersistentStoreAndWait()
    }
    
}
