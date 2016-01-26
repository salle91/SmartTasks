//
//  URLProvider.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "URLProvider.h"

static NSString *const tasksURL = @"https://demo8035300.mockable.io/tasks";

@implementation URLProvider

+ (NSString*)getURLforTasks {
    return tasksURL;
}

@end
