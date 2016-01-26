//
//  TaskTableViewCell.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface TaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTaskTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaskDueDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTaskDaysLeft;
@property (weak, nonatomic) IBOutlet UIView *viewCellDesign;
@property (weak, nonatomic) IBOutlet UIView *viewTaskStateIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTaskStateIndicator;

- (void)populateData:(Task*)task;
- (void)prepareGfx;

@end
