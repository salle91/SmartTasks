//
//  Task.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TaskState) {
    TaskStateUnresolved,
    TaskStateResolved,
    TaskStateCannotBeResolved
};

@interface Task : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *targetDate;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) TaskState taskState;

- (void)deserialize:(NSDictionary*)dictionary;
- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)decoder;
@end
