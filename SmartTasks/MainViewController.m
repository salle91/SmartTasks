//
//  MainViewController.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "MainViewController.h"
#import "WebServiceManager.h"
#import "TaskTableViewCell.h"
#import "TaskDetailsViewController.h"
#import "DRCellSlideAction.h"
#import "DRCellSlideActionView.h"
#import "DRCellSlideGestureRecognizer.h"

static const int taskCellWidth = 298;
static const int taskCellMinHeight = 80;
static const int taskCellSpacingBetweenComponents = 10;

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableViewTasks;
@property (nonatomic, weak) IBOutlet UIView *viewNoTasks;
@property (nonatomic, weak) IBOutlet UIView *viewTasks;
@property (nonatomic, assign) TableViewReloadDirection reloadDirection;
@property (weak, nonatomic) IBOutlet UILabel *labelNoTasksForDay;

@end


@implementation MainViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableViewTasks reloadData];
}

- (void)prepareData {
    [super prepareData];
    self.purpose = MainViewStateTasksLoading;
    if (![HelperMethods isAppStartedFirstTime]) {
        if ([HelperMethods hasInternetConnection]) {
            SHOW_HUD
            [WebServiceManager getAllTasksWithCompletion:^(BOOL success, NSArray *tasks, NSError *error) {
                if (success) {
                    [[TaskManager sharedInstance] saveAllTasksForUser:[[NSMutableArray alloc] initWithArray:tasks]];
                    [HelperMethods setAppIsStartedFirstTime];
                    self.reloadDirection = TableViewReloadDirectionDown;
                    [self reloadView];
                } else {
                    NSLog(@"%@",[error localizedDescription]);
                    HIDE_HUD
                    BAD_REQUEST_ALERT
                }
            }];
        } else {
            HIDE_HUD
            NO_INTERNET_ALERT
        }
    } else {
        if ([[[TaskManager sharedInstance] returnArrayOfTasks] count] > 0) {
            self.reloadDirection = TableViewReloadDirectionDown;
            [self reloadView];
        } else {
            HIDE_HUD
            BAD_REQUEST_ALERT
        }
    }
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
}

- (void)prepareGfx {
    [super prepareGfx];
    HIDE_HUD
    if (self.purpose == MainViewStateTasksAvailable) {
        self.viewNoTasks.hidden = YES;
        self.viewTasks.hidden = NO;
    } else if (self.purpose == MainViewStateNoTasksAvailable){
        [self setView:self.viewNoTasks hidden:NO];
        self.viewTasks.hidden = YES;
    } else {
        self.viewNoTasks.hidden = YES;
        self.viewTasks.hidden = NO;
        SHOW_HUD
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInToday:[[TaskManager sharedInstance] currentSelectedDate]]) {
        self.navigationItem.title = @"Today";
        self.labelNoTasksForDay.text = @"No tasks for today!";
    } else if ([calendar isDateInTomorrow:[[TaskManager sharedInstance] currentSelectedDate]]){
        self.navigationItem.title = @"Tomorrow";
        self.labelNoTasksForDay.text = @"No tasks for tomorrow!";
    } else if ([calendar isDateInYesterday:[[TaskManager sharedInstance] currentSelectedDate]]){
        self.navigationItem.title = @"Yesterday";
        self.labelNoTasksForDay.text = @"No tasks for yesterday!";
    } else {
        self.navigationItem.title = [Converter getFormatedStringFromDate:[[TaskManager sharedInstance] currentSelectedDate]];
        self.labelNoTasksForDay.text = @"No tasks for this day!";
    }
    [self updateNavigationBarIcons];
}

- (void)reloadView {
    [[TaskManager sharedInstance] filterTasksForCurrentlySelectedDay];
    if ([[[TaskManager sharedInstance] arrayTasksForCurrentDay] count] > 0) {
        self.purpose = MainViewStateTasksAvailable;
    } else {
        self.purpose = MainViewStateNoTasksAvailable;
    }
    [self viewWillAppear:NO];
    UITableViewRowAnimation rowAnimation;
    switch(self.reloadDirection) {
        case TableViewReloadDirectionDown:
            rowAnimation = UITableViewRowAnimationBottom;
            break;
        case TableViewReloadDirectionRight:
            rowAnimation =  UITableViewRowAnimationLeft;
            break;
        case TableViewReloadDirectionLeft:
            rowAnimation =  UITableViewRowAnimationRight;
            break;
    }
    [self.tableViewTasks reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:rowAnimation];
}

#pragma mark - View design methods

- (void)updateNavigationBarIcons {
    UIBarButtonItem *negativeSpacerLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacerLeft setWidth:-taskCellSpacingBetweenComponents];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[HelperMethods resizeImage:[UIImage imageNamed:@"back.png"] withHeight:21 andWidth:21] style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonChangeDay:)];
    [backButton setTag:1];
    self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:negativeSpacerLeft,backButton,nil];
    
    UIBarButtonItem *negativeSpacerRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacerRight setWidth:-taskCellSpacingBetweenComponents];
    UIBarButtonItem *backButtonNext = [[UIBarButtonItem alloc] initWithImage:[HelperMethods resizeImage:[UIImage imageWithCGImage:[[UIImage imageNamed:@"back.png"] CGImage] scale:1.0 orientation:UIImageOrientationDown] withHeight:21 andWidth:21] style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonChangeDay:)];
    [backButtonNext setTag:2];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacerRight,backButtonNext,nil];
}

- (void)setView:(UIView*)view hidden:(BOOL)hidden {
    [UIView transitionWithView:view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        [view setHidden:hidden];
    } completion:nil];
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[TaskManager sharedInstance] arrayTasksForCurrentDay] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellTask";
    TaskTableViewCell *cell = [self.tableViewTasks dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.labelTaskTitle.preferredMaxLayoutWidth = taskCellWidth - taskCellSpacingBetweenComponents - taskCellSpacingBetweenComponents;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    NSLog(@"%f",size.width);
    Task *taskDataForCell = [[[TaskManager sharedInstance] arrayTasksForCurrentDay] objectAtIndex:[indexPath row]];
    [cell populateData:taskDataForCell];
    [cell prepareGfx];
    if ([taskDataForCell taskState] == TaskStateUnresolved && ![[TaskManager sharedInstance] isTaskExpired:taskDataForCell]) {
        [self addGestureRecognizersForCell:cell];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateHeightForCellAtIndexPath:indexPath];
}

#pragma mark - TaskDetailsDelegate methods

- (void)refreshTaskListForCurrentDay {
    [self reloadView];
}

#pragma mark - Button actions methods

- (void)actionButtonChangeDay:(id)sender{
    [self changeDateInDirection:[sender tag]];
}

#pragma mark - Swipe gesture methods

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer {
    [self changeDateInDirection:2];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer {
    [self changeDateInDirection:1];
}

- (void)changeDateInDirection:(NSInteger)direction{
    if ([[[TaskManager sharedInstance] returnArrayOfTasks] count] == 0) {
        NO_DATA_ALERT
        return;
    }
    NSDateComponents *dayComponent = [NSDateComponents new];
    switch (direction) {
        case 1:
            dayComponent.day = -1;
            self.reloadDirection = TableViewReloadDirectionLeft;
            break;
        case 2:
            dayComponent.day = 1;
            self.reloadDirection = TableViewReloadDirectionRight;
            break;
    }
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[[TaskManager sharedInstance] currentSelectedDate] options:0];
    [[TaskManager sharedInstance] setCurrentSelectedDate:nextDate];
    [self reloadView];
}

#pragma mark -  DRCellSlideAction methods

- (void)addGestureRecognizersForCell:(UITableViewCell*)cell {
    DRCellSlideGestureRecognizer *gestureRecognizer = [DRCellSlideGestureRecognizer new];
    
    DRCellSlideAction *actionCannotResolve = [DRCellSlideAction actionForFraction:0.33];
    actionCannotResolve.behavior = DRCellSlideActionPullBehavior;
    actionCannotResolve.icon = [HelperMethods resizeImage:[UIImage imageNamed:@"Unresolved sign"] withHeight:20 andWidth:20];
    actionCannotResolve.activeBackgroundColor = UICOLOR_RED;
    actionCannotResolve.inactiveBackgroundColor = UICOLOR_RED;
    actionCannotResolve.didTriggerBlock = [self setTaskStateToCannotBeResolved];

    
    DRCellSlideAction *actionResolve = [DRCellSlideAction actionForFraction:-0.33];
    actionResolve.behavior = DRCellSlideActionPullBehavior;
    actionResolve.icon = [HelperMethods resizeImage:[UIImage imageNamed:@"Resolved sign"] withHeight:20 andWidth:20];
    actionResolve.activeBackgroundColor = UICOLOR_GREEN;
    actionResolve.inactiveBackgroundColor = UICOLOR_GREEN;
    actionResolve.didTriggerBlock = [self setTaskStateToResolved];
    
    [gestureRecognizer addActions:@[actionCannotResolve,actionResolve]];
    
    [cell addGestureRecognizer:gestureRecognizer];
}

- (DRCellSlideActionBlock)setTaskStateToCannotBeResolved {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        Task *updatedTask = [[[TaskManager sharedInstance] arrayTasksForCurrentDay] objectAtIndex:[indexPath row]];
        [updatedTask setTaskState:TaskStateCannotBeResolved];
        [[TaskManager sharedInstance] updateDataSourceForTask:updatedTask];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    };
}

- (DRCellSlideActionBlock)setTaskStateToResolved {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        Task *updatedTask = [[[TaskManager sharedInstance] arrayTasksForCurrentDay] objectAtIndex:[indexPath row]];
        [updatedTask setTaskState:TaskStateResolved];
        [[TaskManager sharedInstance] updateDataSourceForTask:updatedTask];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    };
}

#pragma mark - Helper methods

- (CGFloat)calculateHeightForCellAtIndexPath:(NSIndexPath *)indexPath {
    float height = taskCellMinHeight;
    NSString *textToFitInLabel = [[[[TaskManager sharedInstance] arrayTasksForCurrentDay] objectAtIndex:[indexPath row]] title];
    float textWidth = taskCellWidth - taskCellSpacingBetweenComponents - taskCellSpacingBetweenComponents;
    CGRect textSize = [textToFitInLabel boundingRectWithSize:(CGSize){ .width = textWidth, .height = CGFLOAT_MAX }
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{ NSFontAttributeName:UIFONT_AMSIPRO_BOLD(15)}
                                               context:nil];
    height += textSize.size.height;
    return height;
}

#pragma mark - Segue transition methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showTaskDetails"]){
        TaskDetailsViewController *tvc = (TaskDetailsViewController*) segue.destinationViewController;
        NSIndexPath *taskIndexPath = [self.tableViewTasks indexPathForCell:sender];
        tvc.currentSelectedTask = [[[TaskManager sharedInstance] arrayTasksForCurrentDay] objectAtIndex:[taskIndexPath row]];
    }
}

@end
