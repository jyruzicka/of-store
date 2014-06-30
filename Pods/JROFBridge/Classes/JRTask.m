//
//  JRTask.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRTask.h"
#import "JROmniFocus.h"
#import "OmniFocus.h"

@implementation JRTask

#pragma mark Initializer
-(id)initWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent {
    if (!task)
        self = nil;
    else if (self = [super initWithParent:parent])
        _task = task;

    return self;
}

+(JRTask *)taskWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent {
    return [[self alloc] initWithTask:task parent:parent];
}

+(NSMutableArray *)tasksFromArray:(NSArray *)array parent:(JROFObject *)parent {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:array.count];
    for (OmniFocusTask *t in array)
        [arr addObject:[JRTask taskWithTask:t parent:parent]];
    return arr;
}

#pragma mark Properties
//Dates
-(NSDate *)creationDate {
    if (!_creationDate) _creationDate = self.task.creationDate;
    return _creationDate;
}

-(NSDate *)completionDate {
    if (!self.isCompleted) return nil;
    
    if (!_completionDate) _completionDate = [self.task.completionDate get];
    return _completionDate;
}

-(NSDate *)deferredDate {
    if (!_deferredDate) {
        if (JROmniFocus.instance.version == JROmniFocusVersion1)
            _deferredDate = [self.task.startDate get];
        else
            _deferredDate = [self.task.deferDate get];
    }
    return _deferredDate;
}

-(BOOL)isCompleted {
    return self.task.completed;
}

-(BOOL)isWaiting {
    OmniFocusContext *c = [self.task.context get];
    return (c && [c.name rangeOfString:@"Waiting"].location == 0);
}

-(NSString *)projectName {
    if (!_projectName) _projectName = self.parent.name;
    return _projectName;
}

-(NSString *)projectID {
    if (!_projectID) _projectID = self.parent.id;
    return _projectID;
}


#pragma mark Inherited
-(NSString *)name {
    if (!_name) _name = self.task.name;
    return _name;
}

-(NSString *)id {
    if (!_id) _id = self.task.id;
    return _id;
}

#pragma mark Export types

+(NSDictionary *)columns {
    return @{
        @"name": @"STRING",
        @"projectID": @"STRING",
        @"projectName": @"STRING",
        @"ancestors": @"STRING",
        @"completionDate": @"DATE",
        @"creationDate": @"DATE",
        @"ofid": @"STRING"
    };
}

-(NSDictionary *)asDict {
    return @{
        @"name": self.name,
        @"projectID": self.projectID,
        @"projectName": self.projectName,
        @"ancestors": self.ancestry,
        @"completionDate": (self.completionDate ? self.completionDate : @-1),
        @"creationDate": self.creationDate,
        @"ofid": self.id
    };
}

@end
