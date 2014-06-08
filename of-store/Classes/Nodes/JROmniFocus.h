//
//  JROmniFocus.h
//  of-store
//
// Acts as a wrapper object for omnifocus itself.
// Used to determine which version of OmniFocus is running
// (1, 2 or Pro), whether it's running, and to return the
// default document.
//
// Singleton object. Get the current application with
// +[OmniFocus instance];
//
//  Created by Jan-Yves on 6/06/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JROFObject, OmniFocusApplication;

@interface JROmniFocus : NSObject {
    NSMutableArray *_projects, *_folders;
}

@property OmniFocusApplication *application;
@property NSArray *excludedFolders;

#pragma mark Initializers and factories
-(id)init;
+(id)instance;

#pragma mark Instance methods and properties
-(BOOL)isPro;
-(NSMutableArray *)folders;
-(NSMutableArray *)projects;

//Iterate through all objects in the tree
-(void)each:(void (^)(JROFObject *))function;

@end
