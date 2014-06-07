//
//  JROmniFocus.m
//  of-store
//
//  Created by Jan-Yves on 6/06/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JROmniFocus.h"
#import "JRLogger.h"
#import "OmniFocus.h"

//Need to know about folders and projects
#import "JRFolder.h"
#import "JRProject.h"

//All OmniFocus2 processes start with this string
static const NSString *kJRIdentifierPrefix = @"com.omnigroup.OmniFocus";

//Store current running OmniFocus instance
static OmniFocusApplication *kJROmniFocus;

//String identifying the current running OmniFocus instance. Accessed via +[JROmniFocus processString]
static NSString *kJRProcessString;

//Array of all root JRProjects
static NSMutableArray *kJRProjects;

//Array of all root JRFolders
static NSMutableArray *kJRFolders;

//Ignore root folders with this name
static NSArray *kJRExcludeFolders;

@implementation JROmniFocus

#pragma mark Basic operation
+(BOOL)isRunning{
    return (![self.processString isEqualToString:@""]);
}

+(BOOL)isPro {
    @try {
        [self.omnifocus defaultDocument];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

#pragma mark Root tree elements
+(void)excludeFolders:(NSArray *)folders {
    kJRExcludeFolders = folders;
    kJRFolders = nil; // Reset
}

+(NSMutableArray *)projects {
    if (!kJRProjects) {
        kJRProjects = [NSMutableArray array];
        for (OmniFocusProject *p in self.omnifocus.defaultDocument.projects) {
            JRProject *jrp = [JRProject projectWithProject:p parent:nil];
            [kJRProjects addObject:jrp];
            [jrp populateChildren];
        }
    }
    return kJRProjects;
}

+(NSMutableArray *)folders {
    if (!kJRFolders) {
        kJRFolders = [NSMutableArray array];
        for (OmniFocusFolder *f in self.omnifocus.defaultDocument.folders) {
            //Skip top-level folders with specific names
            if ([kJRExcludeFolders containsObject:f.name]) continue;
            
            JRFolder *jrf = [JRFolder folderWithFolder:f parent:nil];
            [kJRFolders addObject:jrf];
            [jrf populateChildren];
        }
    }
    return kJRFolders;
}

+(void)each:(void (^)(JROFObject *))function {
    for (JRFolder *f in self.folders)
        [f each:function];
    for (JRProject *p in self.projects)
        [p each:function];
}

#pragma mark - Private methods

+(OmniFocusApplication *)omnifocus{
    if (!kJROmniFocus && self.isRunning) {
        [[JRLogger logger] debug:@"Connecting to bundle: %@",self.processString];
        kJROmniFocus = [SBApplication applicationWithBundleIdentifier:self.processString];
    }
    return kJROmniFocus;
}

+(NSString *)processString {
    if (!kJRProcessString) {
        NSArray *apps = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication *app in apps) {
            if (!app.bundleIdentifier) continue;
            NSRange occurance = [app.bundleIdentifier rangeOfString:(NSString *)kJRIdentifierPrefix];
            if (occurance.location != NSNotFound) { //string in the bundle identifier
                kJRProcessString = app.bundleIdentifier;
                break;
            }
        }
        if (!kJRProcessString) kJRProcessString = @"";
    }
    return kJRProcessString;
}

@end
