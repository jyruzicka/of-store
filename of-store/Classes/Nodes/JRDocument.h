//
//  JRDocument.h
//  of-store
//
//  Created by Jan-Yves on 28/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JROFObject.h"

@class OmniFocusDocument;

@interface JRDocument : JROFObject

@property (atomic,readonly) OmniFocusDocument *document;
@property (atomic) NSMutableArray *folders;
@property (atomic) NSMutableArray *projects;

#pragma mark Initializer
-(id)initWithDocument:(OmniFocusDocument *)document;
+(id)documentWithDocument:(OmniFocusDocument *)document;


@end
