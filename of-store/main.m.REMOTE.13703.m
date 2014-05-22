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

void NSPrint(NSString * str,...) {
    va_list args;
    va_start(args,str);
    
    if (![str hasSuffix:@"\n"]) str = [str stringByAppendingString:@"\n"];
    
    NSString *outputString = [[NSString alloc] initWithFormat:str arguments:args];
    va_end(args);
    [outputString writeToFile:@"/dev/stdout" atomically:NO encoding:NSUTF8StringEncoding error:nil];

}

int main(int argc, const char * argv[])
{
    if (argc != 2) {
        NSPrint(@"Please specify a file to output %@ to.", @"data");
        exit(1);
    }

    @autoreleasepool {
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
        if (![db databaseIsLegal]) {
            NSPrint(@"I cannot create a database here. Are you sure the directory exists?");
            exit(1);
        }
        
        JRDocument *root = [JRDocument documentWithDocument:[of defaultDocument]];
        [root populateChildren];
        [root each:^(JROFObject *o){
            if ([o shouldBeRecorded]) {
                NSError *err;
                err = [db saveOFObject:o];
                if (err) NSPrint(@"Error [%i]: %@", err.code, err.localizedDescription);
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
    
        NSString *output = [NSString stringWithFormat:@"%@ and %@ recorded.", projString, taskString];
        NSPrint(output);
    }
    return 0;
}

