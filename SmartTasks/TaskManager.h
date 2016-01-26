//
//  TaskManager.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface TaskManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrayTasksForCurrentDay;
@property (nonatomic, strong) NSDate *currentSelectedDate;

+ (id)sharedInstance;
- (void)saveAllTasksForUser:(NSMutableArray*)arrayOfTasks;
- (NSMutableArray*)returnArrayOfTasks;
- (void)filterTasksForCurrentlySelectedDay;
- (NSString*)getCalculatedDaysLeftForTask:(Task*)task;
- (NSString*)getCalculatedDaysLeftFromNowForTask:(Task*)task;
- (void)updateDataSourceForTask:(Task*)task;
- (BOOL)isTaskExpired:(Task*)task;
- (Task*)createTestTaskForToday;

@end
