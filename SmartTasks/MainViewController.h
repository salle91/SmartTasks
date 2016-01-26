//
//  MainViewController.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaskDetailsDelegate.h"

typedef NS_ENUM(NSInteger, MainViewState) {
    MainViewStateTasksAvailable,
    MainViewStateNoTasksAvailable,
    MainViewStateTasksLoading
};

typedef NS_ENUM(NSInteger, TableViewReloadDirection) {
    TableViewReloadDirectionDown,
    TableViewReloadDirectionLeft,
    TableViewReloadDirectionRight
};

@interface MainViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, TaskDetailsDelegate>

@property (nonatomic,assign) MainViewState purpose;

@end
