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
static NSString *kJRProjectsUpdate = @"UPDATE projects SET name=?,ancestors=?,completionDate=?,creationDate=? WHERE ofid=?;";
static NSString *kJRProjectsInsert = @"INSERT INTO projects (name,ancestors,completionDate,creationDate,ofid) VALUES (?,?,?,?,?);";

static NSString *kJRTasksUpdate = @"UPDATE tasks SET name=?,projectID=?,projectName=?,ancestors=?,completionDate=?,creationDate=? WHERE ofid=?;";
static NSString *kJRTasksInsert = @"INSERT INTO tasks (name,projectID,projectName,ancestors,completionDate,creationDate,ofid) VALUES (?,?,?,?,?,?,?);";

NSUInteger kJRProjectsRecorded = 0;
NSUInteger kJRTasksRecorded = 0;

@implementation JRDatabase

-(id)initWithLocation:(NSString *)location {
    if (self = [super init]) {
        self.location = location;
    }
    return self;
}

-(void)dealloc {
    if (_database) [_database close];
}

+(id)databaseWithLocation:(NSString *)location {
    return [[self alloc] initWithLocation:location];
}

-(BOOL)isLegal {
    NSFileManager *fm = [NSFileManager defaultManager];

    NSString *kanbanPath = [self.location stringByStandardizingPath];
    
    //Check dir exists
    NSArray *dirComponents = [kanbanPath pathComponents];
    NSIndexSet *dirSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dirComponents.count-1)];
    NSString *dir = [[dirComponents objectsAtIndexes:dirSet] componentsJoinedByString:@"/"];
    
    if ([dir isEqualToString:@""]) //current dir
        return YES;
    
    BOOL isDir;
    BOOL fileExists = [fm fileExistsAtPath:dir isDirectory:&isDir];
    return (fileExists && isDir);
}

//Database fetcher
-(FMDatabase *)database {
    if (!_database) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *kanbanPath = [self.location stringByStandardizingPath];
        
        BOOL newDB = (![fm fileExistsAtPath:kanbanPath]);
        _database = [FMDatabase databaseWithPath:kanbanPath];
        [_database open];
        if (newDB) [self populateDatabase];
    }
    return _database;
}

#pragma mark - Database methods
-(NSError *)saveOFObject:(JROFObject *)o {
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

-(NSError *)saveTask:(JRTask *)t {
    NSUInteger count = [self.database intForQuery:@"SELECT COUNT(*) FROM tasks WHERE ofid=?",t.id];
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
                     t.id];
    
    if (![self.database executeUpdate:query withArgumentsInArray:args])
        return [self.database lastError];
    else {
        kJRTasksRecorded++;
        return nil;
    }
}

-(NSError *)saveProject:(JRProject *)p {
    NSUInteger count = [self.database intForQuery:@"SELECT COUNT(*) FROM projects WHERE ofid=?",p.id];
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
                      p.id];
    
    if (![self.database executeUpdate:query withArgumentsInArray:args])
        return [self.database lastError];
    else {
        kJRProjectsRecorded++;
        return nil;
    }
}

#pragma mark Records
-(NSUInteger)projectsRecorded {return kJRProjectsRecorded; }
-(NSUInteger)tasksRecorded {return kJRTasksRecorded; }


#pragma mark - Private methods
-(void)populateDatabase {
    //Tasks
    [self.database update:@"CREATE TABLE tasks (id INTEGER PRIMARY KEY, name STRING, ofid STRING, projectID STRING, projectName STRING, ancestors STRING, creationDate DATE, completionDate DATE);" withErrorAndBindings:nil];
    //Projects
    [self.database update:@"CREATE TABLE projects (id INTEGER PRIMARY KEY, name STRING, ofid STRING, ancestors STRING, creationDate DATE, completionDate DATE);" withErrorAndBindings:nil];
}

@end
