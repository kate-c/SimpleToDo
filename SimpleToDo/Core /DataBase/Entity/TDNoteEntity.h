//
//  TDNoteEntity.h
//  SimpleToDo
//
//  Created by Alex Zimin on 10/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TDNoteGroupEntity;

@interface TDNoteEntity : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * noteId;
@property (nonatomic, retain) NSDate * remindDate;
@property (nonatomic, retain) TDNoteGroupEntity *group;

@end
