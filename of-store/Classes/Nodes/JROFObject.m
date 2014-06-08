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
-(NSString *)id { return nil; }

//Don't record abstract class!
-(BOOL) shouldBeRecorded { return NO; }


-(NSString *)ancestry {
    if (self.parent) {
        NSString *pa = self.parent.ancestry;
        if ([pa isEqualToString:@""])
            return self.parent.name;
        else
            return [NSString stringWithFormat:@"%@|%@",pa, self.parent.name];
    }
    else
        return @"";
}

-(void)each:(void (^)(JROFObject *))function {
    function(self);
}

@end
