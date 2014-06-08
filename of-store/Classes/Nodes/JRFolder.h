//
//  JRFolder.h
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JROFObject.h"
@class OmniFocusFolder;

@interface JRFolder : JROFObject {
    NSString *_name, *_id;
    NSMutableArray *_folders, *_projects;
}

@property (atomic,readonly) OmniFocusFolder *folder;

#pragma mark Initializer
-(id)initWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent;
+(id)folderWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent;

#pragma mark Getters
-(NSMutableArray *)folders;
-(NSMutableArray *)projects;
@end
