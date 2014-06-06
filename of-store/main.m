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

//Options
#import <BRLOptionParser/BRLOptionParser.h>

static const NSString *VERSION_NUMBER = @"1.0.0";

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSError *err;
        
        //BRLOP Arguments
        BOOL debug=NO;
        NSString *dbPath;
        
        //Logger init
        JRLogger *logger = [JRLogger logger];
        
        //------------------------------------------------------------------------------
        // Initialize option parser
        BRLOptionParser *options = [BRLOptionParser new];
        [options setBanner: @"of-store Version %@\n\nusage: %s [--debug] --out=DATABASE\n       %s --help\n",VERSION_NUMBER,argv[0], argv[0]];
        
        [options addOption:"debug" flag:'d' description:@"Activates debug mode, with appropriate output" value:&debug];
        [options addOption:"out" flag:'o' description:@"Name of database. Required" argument:&dbPath];
        
        __weak typeof(options) weakOptions = options;
        [options addOption:"help" flag:'h' description:@"Show this message" block:^{
            [logger log:@"%@",weakOptions.description];
            exit(EXIT_SUCCESS);
        }];
        
        if (![options parseArgc:argc argv:argv error:&err])
            [logger fail:@"%s: %@",argv[0], err.localizedDescription];
        //------------------------------------------------------------------------------
        
        if (debug)
            logger.debugging = YES;
        
        // Check for database location
        if (!dbPath) [logger fail: @"Option --out is required."];
        
        


        
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

