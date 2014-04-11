//
//  JRTask.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRTask.h"
#import "OmniFocus.h"

@interface JRTask ()
@property (atomic) OmniFocusTask *task;
@end

@implementation JRTask

#pragma mark Initializer
-(id)initWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent {
    if (self = [super initWithParent:parent])
        self.task = task;
    return self;
}

+(id)taskWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent {
    return [[self alloc] initWithTask:task parent:parent];
}

#pragma mark Properties

-(NSDate *)creationDate {
    if (!_creationDate)
        _creationDate = self.task.creationDate;
    return _creationDate;
}

-(NSDate *)completionDate {
    if (!self.completed) return nil;
    
    if (!_completionDate)
        _completionDate = [self.task.completionDate get];
    return _completionDate;
}

-(BOOL)completed {
    return self.task.completed;
}

-(NSString *)projectName {
    if (!_projectName)
        _projectName = self.parent.name;
    return _projectName;
}

-(NSString *)projectID {
    if (!_projectID)
        _projectID = self.parent.ofid;
    return _projectID;
}


#pragma mark Inherited
-(NSString *)name {
    if (!_name)
        _name = self.task.name;
    return _name;
}

-(NSString *)ofid {
    if (!_ofid)
        _ofid = self.task.id;
    return _ofid;
}

-(BOOL)shouldBeRecorded {
    return self.completed;
}

@end
