//
//  JRLog.m
//  of-store
//
//  Created by Jan-Yves on 2/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRLog.h"

static NSString *binPath;

@implementation JRLog

+(NSString*)binPath {
    if (binPath == NULL)
        binPath = [@"~/bin/nlog" stringByExpandingTildeInPath];
    return binPath;
}

+(BOOL)isInstalled {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self binPath]];
}

+(void)log:(NSString *)message {
    NSTask *notify = [[NSTask alloc] init];
    notify.launchPath = [self binPath];
    notify.arguments = @[@"add", @"--owner=of-store",message];
    [notify launch];
}

@end
