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
#import "JRLog.h"

//JROFObject classes
#import "JROFObject.h"
#import "JRDocument.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSString *ofs = @"com.omnigroup.omnifocus";
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
        [JRDatabase load];
        
        
        JRDocument *root = [JRDocument documentWithDocument:[of defaultDocument]];
        [root populateChildren];
        [root each:^(JROFObject *o){
            if ([o shouldBeRecorded]) {
                NSError *err;
                err = [JRDatabase saveOFObject:o];
                if (err) NSLog(@"Error: %@", err.description);
            }
        }];
        
        if ([JRLog isInstalled]) {
            NSString *projString;
            NSString *taskString;
            if (JRDatabase.projectsRecorded == 1)
                projString = @"1 project";
            else
                projString = [NSString stringWithFormat:@"%lu projects", JRDatabase.projectsRecorded];
            
            if (JRDatabase.tasksRecorded == 1)
                taskString = @"1 task";
            else
                taskString = [NSString stringWithFormat:@"%lu tasks", JRDatabase.tasksRecorded];
        
            NSString *output = [NSString stringWithFormat:@"%@ and %@ recorded.", projString, taskString];
            [JRLog log:output];
        }

    }
    return 0;
}

