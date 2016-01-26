//
//  TaskTableViewCell.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (void)prepareForReuse {
    self.labelTaskTitle.text = nil;
    self.labelTaskDueDate.text = nil;
    self.labelTaskDaysLeft.text = nil;
    self.gestureRecognizers = nil;
}

- (void)populateData:(Task*)task {
    [self prepareForReuse];
    self.labelTaskTitle.text = task.title;
    self.labelTaskDueDate.text = [Converter getFormatedStringFromDate:task.dueDate];
    self.labelTaskDaysLeft.text = [[TaskManager sharedInstance] getCalculatedDaysLeftForTask:task];
    if (task.taskState == TaskStateResolved) {
        self.viewTaskStateIndicator.hidden = NO;
        self.imageViewTaskStateIndicator.image = [UIImage imageNamed:@"Resolved sign"];
    } else if (task.taskState == TaskStateCannotBeResolved) {
        self.viewTaskStateIndicator.hidden = NO;
        self.imageViewTaskStateIndicator.image = [UIImage imageNamed:@"Unresolved sign"];
    } else {
        self.viewTaskStateIndicator.hidden = YES;
    }
}

- (void)prepareGfx {
    [self.labelTaskTitle sizeToFit];
    [self.labelTaskTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [[self.viewCellDesign layer] setCornerRadius:5.0f];
    [self layoutIfNeeded];
}

@end
