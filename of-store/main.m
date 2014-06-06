//
//  main.m
//  of-store
//
//  Created by Jan-Yves on 1/12/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRDatabase.h"
#import "OmniFocus.h"

//JROFObject classes
#import "JROFObject.h"
#import "JRDocument.h"

//Logging
#import "JRLogger.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        JRLogger *logger = [JRLogger logger];
        if (argc != 2) [logger fail:@"Please specify a file to output data to."];
        
        NSString *ofs = @"com.omnigroup.OmniFocus2";
        // Fetch OmniFocus stuff
        OmniFocusApplication *of = [SBApplication applicationWithBundleIdentifier:ofs];
        
        NSArray *apps = [[NSWorkspace sharedWorkspace] runningApplications];
        BOOL ofRunning = NO;
        for (NSRunningApplication *app in apps)
            if ([app.bundleIdentifier isEqualToString:ofs]) {
                ofRunning = YES;
                break;
            }
        
        if (!ofRunning) return 0;
        
        // Ensure database is up and running
        NSString *dbLocation = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        JRDatabase *db = [JRDatabase databaseWithLocation:dbLocation];
        if (![db databaseIsLegal]) [logger fail: @"I cannot create a database here. Are you sure the directory exists?"];
        
        JRDocument *root = [JRDocument documentWithDocument:[of defaultDocument]];
        [root populateChildren];
        [root each:^(JROFObject *o){
            if ([o shouldBeRecorded]) {
                NSError *err;
                err = [db saveOFObject:o];
                if (err) [logger fail:@"Error [%i]: %@", err.code, err.localizedDescription];
            }
        }];
        
        NSString *projString;
        NSString *taskString;
        if (db.projectsRecorded == 1)
            projString = @"1 project";
        else
            projString = [NSString stringWithFormat:@"%lu projects", db.projectsRecorded];
        
        if (db.tasksRecorded == 1)
            taskString = @"1 task";
        else
            taskString = [NSString stringWithFormat:@"%lu tasks", db.tasksRecorded];
    
        [logger debug:@"%@ and %@ recorded.", projString, taskString];
    }
    return 0;
}

