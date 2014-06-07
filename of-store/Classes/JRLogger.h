//
//  JRLogger.h
//  of-store
//
//  Created by Jan-Yves on 6/06/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRLogger : NSObject

@property BOOL debugging;

+(id)logger;

-(void)log:(NSString *)str,...;
-(void)debug:(NSString *)str,...;
-(void)error:(NSString *)str,...;

-(void)fail:(NSString *)str,...;
@end
