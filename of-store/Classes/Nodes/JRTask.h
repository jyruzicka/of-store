//
//  JRTask.h
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JROFObject.h"
@class OmniFocusTask;
@class JRProject;

@interface JRTask : JROFObject {
    NSString *_name, *_id;
    NSString *_projectName, *_projectID;
    NSDate *_creationDate, *_completionDate;
    BOOL _completed;
}

@property (atomic,readonly) OmniFocusTask *task;

#pragma mark Initializer
-(id)initWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent;
+(id)taskWithTask:(OmniFocusTask *)task parent:(JROFObject *)parent;

#pragma mark Properties
-(NSDate *)creationDate;
-(NSDate *)completionDate;
-(BOOL)completed;
-(NSString *)projectName;
-(NSString *)projectID;
@end
