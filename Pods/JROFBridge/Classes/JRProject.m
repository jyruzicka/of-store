//
//  JRProject.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JROmniFocus.h"
#import "JRProject.h"
#import "OmniFocus.h"

//Children
#import "JRTask.h"

@implementation JRProject

#pragma mark Initializer
-(id)initWithProject:(OmniFocusProject *)project parent:(JROFObject *)parent {
    if (self = [super initWithParent:parent]) {
        _project = project;
    }
    return self;
}

+(id)projectWithProject:(OmniFocusProject *)project parent:(JROFObject *)parent {
    return [[self alloc] initWithProject:project parent:parent];
}

+(NSMutableArray *)projectsFromArray:(NSArray *)array parent:(JROFObject *)parent {
     NSMutableArray *arr = [NSMutableArray arrayWithCapacity:array.count];
    for (OmniFocusProject *p in array)
        [arr addObject: [JRProject projectWithProject:p parent:parent]];
    return arr;
}

#pragma mark Getters

-(NSMutableArray *)tasks {
    if (!_tasks)
        _tasks = [JRTask tasksFromArray: self.project.rootTask.flattenedTasks parent:self];
    return _tasks;
}

-(NSMutableArray *)remainingTasks {
    if (!_remainingTasks) {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"completed == NO"];
        _remainingTasks = [NSMutableArray arrayWithArray:[self.tasks filteredArrayUsingPredicate:p]];
    }
    return _remainingTasks;
}

#pragma mark Properties

-(NSString *)name {
    if (!_name) _name = self.project.name;
    return _name;
}

-(NSString *)id {
    if (!_id) _id = self.project.id;
    return _id;
}

-(NSString *)status {
    if (!_status) {
        JRTask *nextTask = (self.remainingTasks.count > 0 ? self.remainingTasks[0] : nil);
        switch (self.project.status) {
        case OmniFocusProjectStatusActive:
            if (nextTask && nextTask.isWaiting)
                _status = @"Waiting on";
            else if (self.deferralType != JRNotDeferred)
                _status = @"Deferred";
            else
                _status = @"Active";
            
            break;
        case OmniFocusProjectStatusOnHold:
            _status = @"On hold";
            break;
        case OmniFocusProjectStatusDone:
            _status = @"Done";
            break;
        default:
            _status = @"Dropped";
        }
    }
    return _status;
}


-(NSDate *)creationDate {
    if (!_creationDate) _creationDate = self.project.creationDate;
    return _creationDate;
}

-(NSDate *)completionDate {
    if (!self.isCompleted) return nil;
    
    if (!_completionDate) _completionDate = [self.project.completionDate get];
    return _completionDate;
}

-(NSDate *)deferredDate {
    if (!_deferredDate) //Cheat: generate by running deferralType
        [self deferralType];

    return _deferredDate;
}

-(JRDeferralType)deferralType {
    if (!_deferralType) {
        NSDate *now = [NSDate date];
        //Project overrides all
        NSDate *projectDeferDate;
        if (JROmniFocus.instance.version == JROmniFocusVersion1)
            projectDeferDate = [self.project.startDate get];
        else
            projectDeferDate = [self.project.deferDate get];

        if (projectDeferDate && [projectDeferDate laterDate:now] == projectDeferDate) {
            _deferralType = JRProjectDeferred;
            _deferredDate = projectDeferDate;
        }
        else {

            //Then check task
            if (self.remainingTasks.count > 0) {
                NSDate *taskDeferDate = ((JRTask *) self.remainingTasks[0]).deferredDate;
                if (taskDeferDate && [taskDeferDate laterDate:now] == taskDeferDate) {
                    _deferralType = JRFirstTaskDeferred;
                    _deferredDate = taskDeferDate;
                }
                else
                    _deferralType = JRNotDeferred;
            }
            else //Not deferred
                _deferralType = JRNotDeferred;
        }
    }
    return _deferralType;
}

-(NSString *)deferralLabel {
    switch (self.deferralType) {
        case JRProjectDeferred:
            return @"project";
            break;
        case JRFirstTaskDeferred:
            return @"task";
            break;
        default:
            return @"none";
            break;
    }
}

-(BOOL)isCompleted {
    return self.project.completed;
}

#pragma mark Traversing the tree
-(void)eachTask:(void (^)(JRTask *))function {
    for (JRTask *t in self.tasks)
        function(t);
}

#pragma mark Export types
+(NSDictionary *)columns {
    return @{
        @"name": @"STRING",
        @"ancestors": @"STRING",
        @"status": @"STRING",
        @"completionDate": @"DATE",
        @"creationDate": @"DATE",
        @"deferredDate": @"DATE",
        @"ofid": @"STRING",
        @"numberOfTasks": @"INTEGER",
        @"deferralType": @"STRING"
    };
}

-(NSDictionary *)asDict {
    return @{
        @"name": self.name,
        @"ancestors": self.ancestry,
        @"status": self.status,
        @"completionDate": (self.completionDate ? self.completionDate : @-1),
        @"creationDate": self.creationDate,
        @"deferredDate": (self.deferredDate ? self.deferredDate : @-1),
        @"ofid": self.id,
        @"numberOfTasks": @(self.remainingTasks.count),
        @"deferralType": self.deferralLabel
    };
}

@end
