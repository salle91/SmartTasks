//
//  Converter.h
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import <Foundation/Foundation.h>

@interface Converter : NSObject

+ (NSDate*)getFormatedDateFromString:(NSString*)string;
+ (NSDate*)dateWithTimezoneOffset:(NSDate*)date;
+ (NSDate*)dateWithoutTimezoneOffset:(NSDate*)date;
+ (NSDate*)convertToAbbreviatedDateFormat:(NSDate*)date;
+ (NSString*)getFormatedStringFromDate:(NSDate*)date;
+ (NSString*)getStringDifferenceBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;
+ (BOOL)isDate:(NSDate*)date betweenStartDate:(NSDate*)beginDate andEndDate:(NSDate*)endDate;


@end
