//
//  Converter.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "Converter.h"

@implementation Converter

+ (NSDate*)getFormatedDateFromString:(NSString*)string {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *dateFromString= [dateFormatter dateFromString:string];
    return dateFromString;
}

+(NSDate*) dateWithTimezoneOffset:(NSDate*)date{
    NSInteger seconds =[[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *currentDateWithOffset = [date dateByAddingTimeInterval:seconds];
    return currentDateWithOffset;
    
}

+(NSDate*) dateWithoutTimezoneOffset:(NSDate*)date{
    NSInteger seconds =[[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *currentDateWithOffset = [date dateByAddingTimeInterval:-seconds];
    return currentDateWithOffset;
}

+ (NSDate*)convertToAbbreviatedDateFormat:(NSDate*)date {
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    return dateOnly;
}

+ (NSString*)getFormatedStringFromDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

+ (NSString*)getStringDifferenceBetweenStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    NSInteger days = [components day];
    NSMutableString *timeDifference = [[NSMutableString alloc] initWithString:@""];
    if (days >= 1) {
        [timeDifference appendString:[NSString stringWithFormat:@"%ld",(long)days]];
    } else {
        [timeDifference appendString:[NSString stringWithFormat:@"0"]];
    }
    return timeDifference;
}

+ (BOOL)isDate:(NSDate*)date betweenStartDate:(NSDate*)beginDate andEndDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

@end
