//
//  JROFObject.m
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JROFObject.h"

@implementation JROFObject

#pragma mark Initializer
-(id)initWithParent:(JROFObject *)parent {
    if (self = [super init])
        self.parent = parent;
    
    return self;
}

+(id)objectWithParent:(JROFObject *)parent {
    return [[self alloc] initWithParent:parent];
}

-(NSString *)name { return nil; }
-(NSString *)ofid { return nil; }

-(BOOL) isRoot { return NO; }
-(BOOL) shouldBeSkipped { return NO; }
-(BOOL) shouldBeRecorded { return NO; }

-(NSString *)ancestry {
    if (self.isRoot || self.parent.isRoot)
        return @"";
    else {
        NSString *parentsAncestry = self.parent.ancestry;
        if ([parentsAncestry isEqualToString:@""])
            return self.parent.name;
        else
            return [NSString stringWithFormat:@"%@|%@",parentsAncestry, self.parent.name];
    }
}

-(void)populateChildren{}
-(void)each:(void (^)(JROFObject *))function {
    function(self);
}

@end
