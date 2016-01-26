//
//  Constants.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//App Theme Colors & Fonts
#define UICOLOR_GREEN [UIColor colorWithRed:0.075 green:0.537 blue:0.482 alpha:1.00]
#define UICOLOR_YELLOW [UIColor colorWithRed:1.000 green:0.871 blue:0.380 alpha:1.00]
#define UICOLOR_BEIGE [UIColor colorWithRed:0.965 green:0.937 blue:0.871 alpha:1.00]
#define UICOLOR_RED [UIColor colorWithRed:0.937 green:0.294 blue:0.369 alpha:1.00]
#define UICOLOR_BROWN [UIColor colorWithRed:0.412 green:0.369 blue:0.267 alpha:1.00]
#define UICOLOR_ORANGE [UIColor colorWithRed:0.976 green:0.714 blue:0.486 alpha:1.00]

#define UIFONT_AMSIPRO_REGULAR(s) [UIFont fontWithName:@"AmsiPro-Regular" size:s]
#define UIFONT_AMSIPRO_BOLD(s) [UIFont fontWithName:@"AmsiPro-Bold" size:s]

//Alerts and activity indicator views
#define ERROR_ALERT     [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
#define NO_DATA_ALERT     [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"It appears that no data is currently available. Please check again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
#define NO_INTERNET_ALERT     [[[UIAlertView alloc] initWithTitle:@"No Internet connection" message:@"This application requires an active Internet connection. Connect to the Internet and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
#define BAD_REQUEST_ALERT     [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry for the inconvenience, but we weren't able to deliver your tasks. Please come back again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
#define SHOW_HUD    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#define HIDE_HUD    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

#endif
