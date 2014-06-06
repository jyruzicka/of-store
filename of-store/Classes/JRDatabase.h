//
//  JRDatabase.h
//  of-store
//
//  Created by Jan-Yves on 3/12/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JROFObject,  JRProject, JRTask;
@class FMDatabase;


@interface JRDatabase : NSObject {
    FMDatabase *_database;
}

@property NSString *location;

-(id)initWithLocation:(NSString *)location;
+(id)databaseWithLocation:(NSString *)location;

-(BOOL)isLegal;

-(FMDatabase *)database;


-(NSError *)saveOFObject:(JROFObject *)o;
-(NSError *)saveTask:(JRTask *)t;
-(NSError *)saveProject:(JRProject *)p;

-(NSUInteger)projectsRecorded;
-(NSUInteger)tasksRecorded;
@end
