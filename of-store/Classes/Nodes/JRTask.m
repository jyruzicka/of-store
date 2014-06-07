//
//  JRTask.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRTask.h"
#import "OmniFocus.h"

@implementation JRTask

#pragma mark Initializer
-(id)initWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent {
    if (self = [super initWithParent:parent])
        _task = task;
    return self;
}

+(id)taskWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent {
    return [[self alloc] initWithTask:task parent:parent];
}

#pragma mark Properties

-(NSDate *)creationDate {
    if (!_creationDate) _creationDate = self.task.creationDate;
    return _creationDate;
}

-(NSDate *)completionDate {
    if (!self.completed) return nil;
    
    if (!_completionDate) _completionDate = [self.task.completionDate get];
    return _completionDate;
}

-(BOOL)completed {
    return self.task.completed;
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

-(BOOL)shouldBeRecorded {
    return self.completed;
}

@end
