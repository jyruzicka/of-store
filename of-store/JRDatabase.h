//
//  JRDatabase.h
//  of-store
//
//  Created by Jan-Yves on 3/12/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JROFObject;
@class JRProject;
@class JRTask;

@interface JRDatabase : NSObject

+(void)load;

+(NSError *)saveOFObject:(JROFObject *)o;
+(NSError *)saveTask:(JRTask *)t;
+(NSError *)saveProject:(JRProject *)p;

+(NSUInteger)projectsRecorded;
+(NSUInteger)tasksRecorded;
@end
