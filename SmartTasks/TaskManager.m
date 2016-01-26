//
//  TaskManager.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "TaskManager.h"

static NSString *keyForDataArrayInUserDefaults = @"arrayTasksData";

@implementation TaskManager

+ (id)sharedInstance {
    static TaskManager *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [TaskManager new];
        instance.arrayTasksForCurrentDay = [NSMutableArray new];
        instance.currentSelectedDate = [Converter dateWithTimezoneOffset:[NSDate date]];
    });
    return instance;
}

- (void)saveAllTasksForUser:(NSMutableArray*)arrayOfTasks {
    //comment out next 3 lines to remove test data
//    if (![HelperMethods isAppStartedFirstTime]) {
//        [arrayOfTasks addObject:[self createTestTaskForToday]];
//    }
    [HelperMethods saveToUserDefaultsData:arrayOfTasks forKey:keyForDataArrayInUserDefaults];
}

- (NSMutableArray*)returnArrayOfTasks {
    return [HelperMethods retreiveFromUserDefaultsData:[NSMutableArray new] forKey:keyForDataArrayInUserDefaults];
}

- (void)filterTasksForCurrentlySelectedDay {
    NSDate *dateToCompare = [self.currentSelectedDate copy];
    NSTimeInterval lengthDay;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&dateToCompare interval:&lengthDay forDate:dateToCompare];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%@ >= targetDate) AND (%@ <= dueDate)", self.currentSelectedDate, dateToCompare];
    self.arrayTasksForCurrentDay = [[NSMutableArray alloc] initWithArray:[[self returnArrayOfTasks] filteredArrayUsingPredicate:predicate]];
    NSSortDescriptor *sortPriority = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
    NSSortDescriptor *sortOlderDate = [[NSSortDescriptor alloc] initWithKey:@"targetDate" ascending:YES];
    self.arrayTasksForCurrentDay = [[NSMutableArray alloc] initWithArray:[self.arrayTasksForCurrentDay sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortPriority, sortOlderDate, nil]]];
}

- (NSString*)getCalculatedDaysLeftForTask:(Task*)task {
    if (task.taskState != TaskStateUnresolved) {
        return @"/";
    }
    if (([Converter convertToAbbreviatedDateFormat:self.currentSelectedDate] <= [Converter convertToAbbreviatedDateFormat:task.dueDate]) && ([Converter convertToAbbreviatedDateFormat:[NSDate date]] <= [Converter convertToAbbreviatedDateFormat:task.dueDate]) && (task.taskState == TaskStateUnresolved)) {
       return [Converter getStringDifferenceBetweenStartDate:[Converter convertToAbbreviatedDateFormat:self.currentSelectedDate] andEndDate:[Converter convertToAbbreviatedDateFormat:task.dueDate]];
    } else {
        return @"/";
    }
}

- (NSString*)getCalculatedDaysLeftFromNowForTask:(Task*)task {
    if (task.taskState != TaskStateUnresolved) {
        return @"/";
    }
    if (([Converter convertToAbbreviatedDateFormat:self.currentSelectedDate] <= [Converter convertToAbbreviatedDateFormat:task.dueDate]) && ([Converter convertToAbbreviatedDateFormat:[NSDate date]] <= [Converter convertToAbbreviatedDateFormat:task.dueDate]) && (task.taskState == TaskStateUnresolved)) {
        return [Converter getStringDifferenceBetweenStartDate:[Converter convertToAbbreviatedDateFormat:[NSDate date]] andEndDate:[Converter convertToAbbreviatedDateFormat:task.dueDate]];
    } else {
        return @"/";
    }
}

- (void)updateDataSourceForTask:(Task*)task {
    NSMutableArray *array = [self returnArrayOfTasks];
    for (Task *currentTask in array) {
        if (currentTask.uid == task.uid) {
            NSInteger indexInArray = [array indexOfObject:currentTask];
            [array replaceObjectAtIndex:indexInArray withObject:task];
            [self saveAllTasksForUser:array];
            return;
        }
    }
}

- (BOOL)isTaskExpired:(Task*)task {
    if (([Converter convertToAbbreviatedDateFormat:self.currentSelectedDate] <= [Converter convertToAbbreviatedDateFormat:task.dueDate]) && ([Converter convertToAbbreviatedDateFormat:[NSDate date]] <= [Converter convertToAbbreviatedDateFormat:task.dueDate])) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Test data methods

- (Task*)createTestTaskForToday {
    Task *taskForToday = [Task new];
    taskForToday.uid = @"0000";
    taskForToday.title = @"Task for today";
    taskForToday.targetDate = [Converter dateWithTimezoneOffset:[NSDate date]];
    [[TaskManager sharedInstance] setCurrentSelectedDate:[Converter dateWithTimezoneOffset:[NSDate date]]];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 2;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[[TaskManager sharedInstance] currentSelectedDate] options:0];
    taskForToday.dueDate = nextDate;
    taskForToday.taskDescription = @"Be happy and smile. Life is beautiful! :)";
    taskForToday.priority = 1;
    return taskForToday;
    
}

@end
