//
//  main.m
//  of-store
//
//  Created by Jan-Yves on 1/12/13.
//  Copyright (c) 2013 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

// OmniFocus base
#import <JROFBridge/JROmniFocus.h>
#import <JROFBridge/JRDatabase.h>
#import <JROFBridge/JRTask.h>
#import <JROFBridge/JRProject.h>
//#import "JRDatabase.h"
//#import "JROmniFocus.h"
//#import "JROFObject.h"

//Logging
#import "JRLogger.h"

//Options
#import <BRLOptionParser/BRLOptionParser.h>

static const NSString *VERSION_NUMBER = @"2.1.0";

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSError *err;
        
        //BRLOP Arguments
        BOOL debug=NO;
        NSString *dbPath;
        NSString *excludeFolders;
        
        //Logger init
        JRLogger *logger = [JRLogger logger];
        
        //------------------------------------------------------------------------------
        // Initialize option parser
        BRLOptionParser *options = [BRLOptionParser new];
        [options setBanner: @"of-store Version %@\n\nusage: %s [--debug] --out=DATABASE\n       %s --help\n",VERSION_NUMBER,argv[0], argv[0]];
        
        [options addOption:"debug" flag:'d' description:@"Activates debug mode, with appropriate output" value:&debug];
        [options addOption:"out" flag:'o' description:@"Name of database. Required" argument:&dbPath];
        [options addOption:"exclude" flag:'x' description:@"Exclude projects in these top-level folders" argument:&excludeFolders];

        
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
        
        //Quit if OmniFocus isn't running
        JROmniFocus *of = [JROmniFocus instance];
        if (!of) {
            [logger debug:@"Omnifocus isn't running. Quitting..."];
            exit(EXIT_SUCCESS);
        }
        
        if (debug) {
            NSString *vers;
            switch(of.version) {
                case JROmniFocusVersion1:
                    vers = @"1";
                    break;
                case JROmniFocusVersion2:
                    vers = @"2 Standard";
                    break;
                default:
                    vers = @"2 Pro";
            }
            
            [logger debug: @"OmniFocus version detected: OmniFocus %@",vers];
        }
        
        //Quit if not pro
        if (!of.version == JROmniFocusVersion2) [logger fail:@"You appear to be using OmniFocus 2 Standard. kanban-fetch will only work with OmniFocus 2 Pro. If you have just purchased OmniFocus Pro, try restarting OmniFocus.\nSorry for the inconvenience!"];
        
        //Determine path to write to
        [logger debug:@"Setting database path to %@", dbPath];
        JRDatabase *db = [JRDatabase databaseWithLocation:dbPath type:(JRDatabaseProjects | JRDatabaseTasks)];

        if (!db.canExist)
            [logger fail:@"Cannot create database at location: %@", dbPath];
        //TKTKTK add in fail clauses if database won't support us here
        
        //Determine folder exclusion
        if (excludeFolders) {
            [logger debug:@"Excluding folders: %@",excludeFolders];
            of.excludedFolders = [excludeFolders componentsSeparatedByString:@","];
        }
        
        void (^block)(JROFObject *) = ^(JROFObject *o){
            if (o.isCompleted) {
                [logger debug:@"  Saving %@: %@",o.className, o.name];
                NSError *err = [db saveOFObject:o];
                if (err) [logger fail:@"Error while saving %@ %@\n[%i]: %@", o.className, o.name, err.code, err.localizedDescription];
            }
        };
        
        [logger debug:@"Writing tasks:"];
        [of eachTask:block];
        [logger debug:@"Writing projects:"];
        [of eachProject:block];
        
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
        [logger debug:@"Success!"];
    }
    return 0;
}

