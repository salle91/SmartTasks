//
//  HelperMethods.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 24/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperMethods : UITableViewCell

+ (BOOL)hasInternetConnection;
+ (BOOL)isAppStartedFirstTime;
+ (void)setAppIsStartedFirstTime;
+ (void)saveToUserDefaultsData:(id)senderData forKey:(NSString*)key;
+ (id)retreiveFromUserDefaultsData:(id)expectedData forKey:(id)key;
+ (UIImage *)resizeImage:(UIImage *)originalImage withHeight:(int)height andWidth:(int)width;

@end
