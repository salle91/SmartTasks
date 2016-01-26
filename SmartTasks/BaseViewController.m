//
//  BaseViewController.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 23/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskDetailsViewController.h"

@implementation BaseViewController

#pragma mark - init methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareGfx];
}

- (void)prepareData {
    
}

- (void)prepareGfx {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = UICOLOR_YELLOW;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar hideBottomHairline];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : UIFONT_AMSIPRO_BOLD(16)}];
        
}


@end
