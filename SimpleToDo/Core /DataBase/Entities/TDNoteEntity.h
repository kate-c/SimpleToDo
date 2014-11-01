//
//  TDNoteEntity.h
//  SimpleToDo
//
//  Created by Alex Zimin on 02/11/14.
//  Copyright (c) 2014 Katrin Chirkova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TDNoteEntity : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * noteId;
@property (nonatomic, retain) NSDate * remindDate;

@end
