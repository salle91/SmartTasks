//
//  HelperMethods.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 24/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "HelperMethods.h"
#import "Reachability.h"

@implementation HelperMethods

+ (BOOL)hasInternetConnection {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isAppStartedFirstTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL valueFirstTime = [defaults boolForKey:@"isNotFirstTime"];
    return valueFirstTime;
}

+ (void)setAppIsStartedFirstTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isNotFirstTime"];
    [defaults synchronize];
}

+ (void)saveToUserDefaultsData:(id)senderData forKey:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([senderData isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *arrayData = (NSMutableArray*)senderData;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrayData];
        [userDefaults setObject:data forKey:key];
        [userDefaults synchronize];
    }
}

+ (id)retreiveFromUserDefaultsData:(id)expectedData forKey:(id)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([expectedData isKindOfClass:[NSMutableArray class]]) {
        NSData *data = [userDefaults objectForKey:key];
        NSMutableArray *arrayOfData = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        return arrayOfData;
    }
    return expectedData;
}

+ (UIImage *)resizeImage:(UIImage *)originalImage withHeight:(int)height andWidth:(int)width {
    CGSize destinationSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(destinationSize, NO, 1.0);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
