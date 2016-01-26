//
//  TaskDetailsDelegate.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 24/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TaskDetailsDelegate <NSObject>

@required
- (void)refreshTaskListForCurrentDay;

@end
