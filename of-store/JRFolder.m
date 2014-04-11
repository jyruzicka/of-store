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

static NSArray *kJRForbiddenNames;

@interface JRFolder ()
@property (atomic) OmniFocusFolder *folder;
@end

@implementation JRFolder
#pragma mark Initializer
-(id)initWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent {
    if (self = [super initWithParent:parent]) {
        self.folder = folder;
        self.folders = [NSMutableArray array];
        self.projects = [NSMutableArray array];
    }
    
    return self;
}

+(id)folderWithFolder:(OmniFocusFolder *)folder parent:(JROFObject *)parent {
    return [[self alloc] initWithFolder:folder parent:parent];
}

#pragma mark Properties
//-(NSArray *)folders {
//    if (!_folders)
//        _folders = self.folder.folders;
//    return _folders;
//}
//
//-(NSArray *)projects {
//    if (!_projects)
//        _projects = self.folder.projects;
//    return _projects;
//}

#pragma mark Inherited
-(NSString *)name {
    if (!_name)
        _name = self.folder.name;
    return _name;
}

-(NSString *)ofid {
    if (!_ofid)
        _ofid = self.folder.id;
    return _ofid;
}

-(BOOL)shouldBeSkipped {
    return [[JRFolder forbiddenNames] containsObject:self.name];
}

-(void)populateChildren {
    if (self.shouldBeSkipped) return;
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
         
#pragma mark Private methods
+(NSArray *)forbiddenNames {
    if (!kJRForbiddenNames)
        kJRForbiddenNames = @[@"Recurring Tasks",@"Template"];
    return kJRForbiddenNames;
}

@end