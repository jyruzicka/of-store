//
//  JRDatabase.m
//  of-store
//
//  Created by Jan-Yves on 3/12/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRDatabase.h"

//Objects to save
#import "JROFObject.h"
#import "JRProject.h"
#import "JRTask.h"

//Database
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseAdditions.h>

//Constants
static FMDatabase *kJRDatabase;
static NSString *kJRProjectsUpdate = @"UPDATE projects SET name=?,ancestors=?,completionDate=?,creationDate=? WHERE ofid=?;";
static NSString *kJRProjectsInsert = @"INSERT INTO projects (name,ancestors,completionDate,creationDate,ofid) VALUES (?,?,?,?,?);";

static NSString *kJRTasksUpdate = @"UPDATE tasks SET name=?,projectID=?,projectName=?,ancestors=?,completionDate=?,creationDate=? WHERE ofid=?;";
static NSString *kJRTasksInsert = @"INSERT INTO tasks (name,projectID,projectName,ancestors,completionDate,creationDate,ofid) VALUES (?,?,?,?,?,?,?);";

NSUInteger kJRProjectsRecorded = 0;
NSUInteger kJRTasksRecorded = 0;

@implementation JRDatabase

// Checks to make sure the database is there and so on
+(void)load {
    if (!kJRDatabase) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *kanbanPath = [@"~/.kb" stringByExpandingTildeInPath];
        [fm createDirectoryAtPath:kanbanPath withIntermediateDirectories:NO attributes:nil error:nil];
        [fm changeCurrentDirectoryPath:kanbanPath];
        BOOL newDB = (![fm fileExistsAtPath:@"of-store.db"]);
        
        kJRDatabase = [FMDatabase databaseWithPath:@"of-store.db"];
        [kJRDatabase open];
        
        if (newDB) [self populateDatabase];
    }
}

#pragma mark - Database methods
+(NSError *)saveOFObject:(JROFObject *)o {
    if ([o isKindOfClass:[JRTask class]])
        return [self saveTask:(JRTask *)o];
    else if ([o isKindOfClass:[JRProject class]])
        return [self saveProject:(JRProject *)o];
    else {
        NSString *desc = [NSString stringWithFormat:@"JRDatabase tried to save a %@ to file. Can only save JRTasks and JRProjects", [o className]];
        NSError *err = [NSError errorWithDomain:NSMachErrorDomain
                                           code:1
                                       userInfo:@{NSLocalizedDescriptionKey: desc}];
        return err;
                                                                                    
    }
}

+(NSError *)saveTask:(JRTask *)t {
    NSUInteger count = [kJRDatabase intForQuery:@"SELECT COUNT(*) FROM tasks WHERE ofid=?",t.ofid];
    NSString *query;
    if (count > 0) // UPDATE required
        query = kJRTasksUpdate;
    else
        query = kJRTasksInsert;
    
    NSArray *args = @[
                     t.name,
                     t.projectID,
                     t.projectName,
                     t.ancestry,
                     t.completionDate,
                     t.creationDate,
                     t.ofid];
    
    if (![kJRDatabase executeUpdate:query withArgumentsInArray:args])
        return [kJRDatabase lastError];
    else {
        kJRTasksRecorded++;
        return nil;
    }
}

+(NSError *)saveProject:(JRProject *)p {
    NSUInteger count = [kJRDatabase intForQuery:@"SELECT COUNT(*) FROM projects WHERE ofid=?",p.ofid];
    NSString *query;
    if (count > 0) // UPDATE required
        query = kJRProjectsUpdate;
    else
        query = kJRProjectsInsert;
    
    NSArray *args = @[
                      p.name,
                      p.ancestry,
                      p.completionDate,
                      p.creationDate,
                      p.ofid];
    
    if (![kJRDatabase executeUpdate:query withArgumentsInArray:args])
        return [kJRDatabase lastError];
    else {
        kJRProjectsRecorded++;
        return nil;
    }
}

#pragma mark Records
+(NSUInteger)projectsRecorded {return kJRProjectsRecorded; }
+(NSUInteger)tasksRecorded {return kJRTasksRecorded; }


#pragma mark - Private methods
+(void)populateDatabase {
    //Tasks
    [kJRDatabase update:@"CREATE TABLE tasks (id INTEGER PRIMARY KEY, name STRING, ofid STRING, projectID STRING, projectName STRING, ancestors STRING, creationDate DATE, completionDate DATE);" withErrorAndBindings:nil];
    //Projects
    [kJRDatabase update:@"CREATE TABLE projects (id INTEGER PRIMARY KEY, name STRING, ofid STRING, ancestors STRING, creationDate DATE, completionDate DATE);" withErrorAndBindings:nil];
}

@end
