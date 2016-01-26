//
//  TaskDetailsViewController.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Task.h"
#import "TaskDetailsDelegate.h"

@interface TaskDetailsViewController : BaseViewController

@property (nonatomic, strong) Task *currentSelectedTask;
@property (strong,nonatomic) id<TaskDetailsDelegate> delegate;

@end
