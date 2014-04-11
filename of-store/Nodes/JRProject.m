//
//  JRProject.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRProject.h"
#import "OmniFocus.h"
//Children
#import "JRTask.h"

@interface JRProject ()
@property (atomic) OmniFocusProject *project;
@end

@implementation JRProject

#pragma mark Initializer
-(id)initWithProject:(OmniFocusProject *)project parent:(JROFObject *)parent {
    if (self = [super initWithParent:parent]) {
        self.project = project;
        self.tasks = [NSMutableArray array];
    }
    return self;
}

+(id)projectWithProject:(OmniFocusProject *)project parent:(JROFObject *)parent {
    return [[self alloc] initWithProject:project parent:parent];
}

#pragma mark Properties
//-(NSArray *)tasks {
//    if (!_tasks) { //TODO try simplifying
//        NSArray *fTasks = self.project.rootTask.flattenedTasks;
//        NSMutableArray *runningArr = [NSMutableArray arrayWithCapacity:[fTasks count]];
//        for (OmniFocusFlattenedTask *ft in fTasks)
//            [runningArr addObject:(OmniFocusTask *)ft];
//        _tasks = [NSArray arrayWithArray:runningArr];
//    }
//    
//    return _tasks;
//}

-(NSDate *)creationDate {
    if (!_creationDate)
        _creationDate = self.project.creationDate;
    return _creationDate;
}

-(NSDate *)completionDate {
    if (!self.completed) return nil;
    
    if (!_completionDate)
        _completionDate = [self.project.completionDate get];
    return _completionDate;
}

-(BOOL)completed {
    return self.project.completed;
}

#pragma mark Inherited
-(NSString *)name {
    if (!_name)
        _name = self.project.name;
    return _name;
}

-(NSString *)ofid {
    if (!_ofid)
        _ofid = self.project.id;
    return _ofid;
}

-(BOOL)shouldBeRecorded {
    return self.completed;
}

-(void)populateChildren {
    for (OmniFocusFlattenedTask *ft in self.project.rootTask.flattenedTasks) {
        JRTask *jrt = [JRTask taskWithTask:(OmniFocusTask *)ft parent:self];
        [self.tasks addObject:jrt]; // Tasks do no populate children
    }
}

-(void)each:(void (^)(JROFObject *))function {
    function(self);
    for (JRTask *t in self.tasks)
        [t each:function];
}

@end
