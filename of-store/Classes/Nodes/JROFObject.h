//
//  JROFObject.h
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JROFObject : NSObject

@property (atomic) JROFObject *parent;

#pragma mark Initializer
-(id)initWithParent:(JROFObject *)parent;
+(id)objectWithParent:(JROFObject *)parent;

#pragma mark Properties
-(NSString *)name;
-(NSString *)id;

#pragma mark Derived methods
//Should this object be recorded to the database?
-(BOOL)shouldBeRecorded;

-(NSString *)ancestry;
-(void)populateChildren;
-(void)each:(void (^)(JROFObject *))function;
@end
