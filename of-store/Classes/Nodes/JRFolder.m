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
        self.folders = [NSMutableArray array];
        self.projects = [NSMutableArray array];
    }
    
    return self;
}

+(id)folderWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent {
    return [[self alloc] initWithFolder:folder parent:parent];
}

#pragma mark Inherited
-(NSString *)name {
    if (!_name) _name = self.folder.name;
    return _name;
}

-(NSString *)id {
    if (!_id) _id = self.folder.id;
    return _id;
}

-(void)populateChildren {
    for (OmniFocusFolder *f in self.folder.folders) {
        JRFolder *jrf = [JRFolder folderWithFolder:f parent:self];
        [self.folders addObject:jrf];
        [jrf populateChildren];
    }
    for (OmniFocusProject *p in self.folder.projects) {
        JRProject *jrp = [JRProject projectWithProject:p parent:self];
        [self.projects addObject:jrp];
        [jrp populateChildren];
    }
}

-(void)each:(void (^)(JROFObject *))function {
    function(self);
    for (JRFolder *f in self.folders)
        [f each:function];
    for (JRProject *p in self.projects)
        [p each:function];
}
@end
