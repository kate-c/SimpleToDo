//
//  TDNoteGroupEntity.h
//  SimpleToDo
//
//  Created by Alex Zimin on 10/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TDNoteEntity;

@interface TDNoteGroupEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * maxNoteId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * noteGroupId;
@property (nonatomic, retain) NSNumber * source;
@property (nonatomic, retain) NSSet *notes;
@end

@interface TDNoteGroupEntity (CoreDataGeneratedAccessors)

- (void)addNotesObject:(TDNoteEntity *)value;
- (void)removeNotesObject:(TDNoteEntity *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
