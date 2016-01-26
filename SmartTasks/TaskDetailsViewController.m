//
//  TaskDetailsViewController.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "TaskDetailsViewController.h"

static const int taskCellSpacingBetweenComponents = 10;

@interface TaskDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTaskTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDueDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDaysLeft;
@property (weak, nonatomic) IBOutlet UITextView *textViewTaskDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelTaskState;

@property (weak, nonatomic) IBOutlet UIView *viewTaskDetails;
@property (weak, nonatomic) IBOutlet UIView *viewButtonResolve;
@property (weak, nonatomic) IBOutlet UIView *viewButtonCannotResolve;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewResolvedSign;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUnresolvedSign;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeightLabelTaskTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeightTextViewDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeightViewTaskDetails;


@end

@implementation TaskDetailsViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)prepareData {
    [super prepareData];
    self.labelTaskTitle.text = self.currentSelectedTask.title;
    self.labelDueDate.text = [Converter getFormatedStringFromDate:self.currentSelectedTask.dueDate];
    self.labelDaysLeft.text = [[TaskManager sharedInstance] getCalculatedDaysLeftFromNowForTask:self.currentSelectedTask];
    self.textViewTaskDescription.text = self.currentSelectedTask.taskDescription;
}

- (void)prepareGfx {
    [super prepareGfx];
    self.navigationItem.title = @"Task details";
    self.viewTaskDetails.layer.cornerRadius = 5;
    self.viewButtonResolve.layer.cornerRadius = 5;
    self.viewButtonCannotResolve.layer.cornerRadius = 5;
    [self.labelTaskTitle sizeToFit];
    [self.labelTaskTitle setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *textToFitInLabel = self.currentSelectedTask.title;
    float textWidth = self.viewTaskDetails.bounds.size.width - taskCellSpacingBetweenComponents - taskCellSpacingBetweenComponents;
    CGRect textSizeTitle = [textToFitInLabel boundingRectWithSize:(CGSize){ .width = textWidth, .height = CGFLOAT_MAX }
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{ NSFontAttributeName:UIFONT_AMSIPRO_BOLD(20)}
                                                     context:nil];
    if  (textSizeTitle.size.height > self.layoutConstraintHeightLabelTaskTitle.constant) {
        self.layoutConstraintHeightViewTaskDetails.constant -= self.layoutConstraintHeightLabelTaskTitle.constant;
        self.layoutConstraintHeightLabelTaskTitle.constant = textSizeTitle.size.height;
        self.layoutConstraintHeightViewTaskDetails.constant += textSizeTitle.size.height;
    }
    textToFitInLabel = self.currentSelectedTask.taskDescription;
    CGRect textSizeDescription = [textToFitInLabel boundingRectWithSize:(CGSize){ .width = textWidth, .height = CGFLOAT_MAX }
                                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                       attributes:@{ NSFontAttributeName:UIFONT_AMSIPRO_BOLD(11)}
                                                          context:nil];
    if  (textSizeDescription.size.height > self.layoutConstraintHeightTextViewDescription.constant) {
        self.layoutConstraintHeightViewTaskDetails.constant -= self.layoutConstraintHeightTextViewDescription.constant;
        self.layoutConstraintHeightTextViewDescription.constant = textSizeDescription.size.height;
        self.layoutConstraintHeightViewTaskDetails.constant += textSizeDescription.size.height;
    }
    if (self.currentSelectedTask.taskState == TaskStateResolved) {
        self.viewButtons.hidden = YES;
        self.imageViewResolvedSign.hidden = NO;
        self.imageViewUnresolvedSign.hidden = YES;
        self.labelTaskTitle.textColor = UICOLOR_GREEN;
        self.labelDueDate.textColor = UICOLOR_GREEN;
        self.labelDaysLeft.textColor = UICOLOR_GREEN;
        self.labelTaskState.text = @"Resolved";
        self.labelTaskState.textColor = UICOLOR_GREEN;
    } else if (self.currentSelectedTask.taskState == TaskStateCannotBeResolved) {
        self.viewButtons.hidden = YES;
        self.imageViewResolvedSign.hidden = YES;
        self.imageViewUnresolvedSign.hidden = NO;
        self.labelTaskTitle.textColor = UICOLOR_RED;
        self.labelDueDate.textColor = UICOLOR_RED;
        self.labelDaysLeft.textColor = UICOLOR_RED;
        self.labelTaskState.text = @"Unresolved";
        self.labelTaskState.textColor = UICOLOR_RED;
    } else {
        if (![[TaskManager sharedInstance] isTaskExpired:self.currentSelectedTask]) {
           self.viewButtons.hidden = NO;
        } else {
            self.viewButtons.hidden = YES;
        }
        self.imageViewResolvedSign.hidden = YES;
        self.imageViewUnresolvedSign.hidden = YES;
        self.labelTaskTitle.textColor = UICOLOR_RED;
        self.labelDueDate.textColor = UICOLOR_RED;
        self.labelDaysLeft.textColor = UICOLOR_RED;
        self.labelTaskState.text = @"Unresolved";
        self.labelTaskState.textColor = UICOLOR_ORANGE;
    }
}

#pragma mark - Button action methods

- (IBAction)actionResolveTask:(id)sender {
    self.currentSelectedTask.taskState = TaskStateResolved;
    self.labelDaysLeft.text = [[TaskManager sharedInstance] getCalculatedDaysLeftFromNowForTask:self.currentSelectedTask];
    [[TaskManager sharedInstance] updateDataSourceForTask:self.currentSelectedTask];
    [self.delegate refreshTaskListForCurrentDay];
    [self viewWillAppear:NO];
}

- (IBAction)actionCannotResolveTask:(id)sender {
    self.currentSelectedTask.taskState = TaskStateCannotBeResolved;
    self.labelDaysLeft.text = [[TaskManager sharedInstance] getCalculatedDaysLeftFromNowForTask:self.currentSelectedTask];
    [[TaskManager sharedInstance] updateDataSourceForTask:self.currentSelectedTask];
    [self.delegate refreshTaskListForCurrentDay];
    [self viewWillAppear:NO];
}


@end
