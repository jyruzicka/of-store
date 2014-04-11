//
//  JRLog.h
//  of-store
//
//  Created by Jan-Yves on 2/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRLog : NSObject

+(BOOL)isInstalled;
+(void)log:(NSString *)message;

@end
