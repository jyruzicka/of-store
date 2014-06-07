//
//  JRProject.h
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JROFObject.h"
@class OmniFocusProject;

@interface JRProject : JROFObject {
    NSString *_name, *_id;
    NSDate *_creationDate, *_completionDate;
    BOOL _completed;
}

@property (atomic,readonly) OmniFocusProject *project;
@property (atomic,readonly) NSMutableArray *tasks;

#pragma mark Initializer
-(id)initWithProject:(OmniFocusProject *)project parent:(JROFObject *)parent;
+(id)projectWithProject:(OmniFocusProject *)project parent:(JROFObject *)parent;

#pragma mark Properties
-(NSDate *)creationDate;
-(NSDate *)completionDate;
-(BOOL)completed;
@end
