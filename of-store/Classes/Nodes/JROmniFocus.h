//
//  JROmniFocus.h
//  of-store
//
// Acts as a wrapper object for omnifocus itself.
// Used to determine which version of OmniFocus is running
// (1, 2 or Pro), whether it's running, and to return the
// default document.
//
//  Created by Jan-Yves on 6/06/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JROFObject;

@interface JROmniFocus : NSObject

#pragma mark Basic operation
+(BOOL)isRunning;
+(BOOL)isPro;

#pragma mark Root tree elements
+(void)excludeFolders:(NSArray *)folders;
+(NSMutableArray *)folders;
+(NSMutableArray *)projects;
+(void)each:(void (^)(JROFObject *))function;

@end
