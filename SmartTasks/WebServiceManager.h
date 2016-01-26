//
//  WebServiceManager.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceManager : NSObject

+ (void)getAllTasksWithCompletion:(void(^)(BOOL success, NSArray *tasks, NSError *error))completion;

@end
