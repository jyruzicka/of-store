//
//  JRLog.m
//  of-store
//
//  Created by Jan-Yves on 2/01/14.
//  Copyright (c) 2014 Jan-Yves Ruzicka. All rights reserved.
//

#import "JRLog.h"

@implementation JRLog

+(void)log:(NSString *)message {
    NSTask *notify = [[NSTask alloc] init];
    notify.launchPath = @"~/bin/nlog";
    notify.arguments = @[@"add", @"--owner=of-store",message];
    [notify launch];
}

@end
