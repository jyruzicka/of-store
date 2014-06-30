//
//  JRFolder.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRFolder.h"
#import "OmniFocus.h"

//Children
#import "JRProject.h"

static NSArray *kJRExcludedFolders;

@implementation JRFolder
#pragma mark Initializer
-(id)initWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent {
    if (self = [super initWithParent:parent]) {
        _folder = folder;
    }
    
    return self;
}

+(id)folderWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent {
    return [[self alloc] initWithFolder:folder parent:parent];
}

+(NSMutableArray *)foldersFromArray:(NSArray *)array parent:(JROFObject *)parent{
    return [self foldersFromArray:array parent:parent excluding:nil];
}

+(NSMutableArray *)foldersFromArray:(NSArray *)array parent:(JROFObject *)parent excluding:(NSArray *)exclusions {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:array.count];
    for (OmniFocusFolder *f in array) {
        if ([exclusions containsObject: f.name]) continue;
        [arr addObject:[JRFolder folderWithFolder:f parent:parent]];
    }
    return arr;
}

#pragma mark Getters
-(NSMutableArray *)folders {
    if (!_folders)
        _folders = [JRFolder foldersFromArray: self.folder.folders parent:self];
    return _folders;
}

-(NSMutableArray *)projects {
    if (!_projects)
       _projects = [JRProject projectsFromArray:self.folder.projects parent:self];
    return _projects;
}

#pragma mark Properties
-(NSString *)name {
    if (!_name) _name = self.folder.name;
    return _name;
}

-(NSString *)id {
    if (!_id) _id = self.folder.id;
    return _id;
}

#pragma mark Traversing the tree
-(void)eachTask:(void (^)(JRTask *))function {
    for (JRFolder *f in self.folders)
        [f eachTask:function];
    for (JRProject *p in self.projects)
        [p eachTask:function];
}

-(void)eachProject:(void (^)(JRProject *))function {
    for (JRFolder *f in self.folders)
        [f eachProject:function];
    for (JRProject *p in self.projects)
        function(p);
}

@end
