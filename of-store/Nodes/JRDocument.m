//
//  JRDocument.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRDocument.h"
#import "OmniFocus.h"
//Children
#import "JRFolder.h"
#import "JRProject.h"

@interface JRDocument ()
@property (atomic) OmniFocusDocument *document;
@end

@implementation JRDocument

#pragma mark Initializer

-(id)initWithDocument:(OmniFocusDocument *)document {
    if (self = [super initWithParent:nil]) {
        self.document = document;
        self.folders = [NSMutableArray array];
        self.projects = [NSMutableArray array];
    }
    
    return self;
}

+(id)documentWithDocument:(OmniFocusDocument *)document {
    return [[self alloc] initWithDocument:document];
}

#pragma mark Properties

//-(NSArray *)folders {
//    if (!_folders)
//        _folders = [self.document folders];
//    return _folders;
//}
//
//-(NSArray *)projects {
//    if (!_projects)
//        _projects = [self.document projects];
//    return _projects;
//}

#pragma mark Inherited

-(BOOL)isRoot { return YES; }

-(void)populateChildren {
    for (OmniFocusFolder *f in self.document.folders) {
        JRFolder *jrf = [JRFolder folderWithFolder:f parent:self];
        [self.folders addObject:jrf];
        [jrf populateChildren];
    }
    for (OmniFocusProject *p in self.document.projects) {
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
