//
//  NSDateUtilities
//  SQTaxi
//
//  Created by Huang Yanan on 16/7/28.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

#define D_BII_DATE_Format @"yyyy/MM/dd"
#define D_BII_DATE_Format2 @"yyyy-MM-dd"

#define D_BII_TIME_Format @"HH:mm:ss"

#define D_BII_TIME_Format2 @"HH:mm"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

typedef NS_ENUM(NSInteger, MBExecuteType) {
    MBExecuteTypeMonth = 1,
    MBExecuteTypeDoubleWeek,
    MBExecuteTypeWeek,
    MBExecuteTypeDay
};

@interface NSDate (Utilities)

- (NSDate *) monthsAgo:(NSInteger)months;       //几个月前
- (NSDate *) monthsLater:(NSInteger)months;     //几个月后

- (NSDate *) daysAgo:(NSInteger)days;           //几天前
- (NSDate *) daysLater:(NSInteger)days;         //几天后

- (NSDate *) hoursAgo:(NSInteger)hours;         //几小时前
- (NSDate *) hoursLater:(NSInteger)hours;       //几小时后
    
- (NSDate *) minutesAgo:(NSInteger)minutes;     //几分钟前
- (NSDate *) minutesLater:(NSInteger)minutes;   //几分钟后

+ (NSDate *)dateWithTimeIntervalString:(NSString *)string;

+ (NSDate *) dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+ (NSDate *) dateWithYear:(NSInteger)year
                    month:(NSInteger)month
                      day:(NSInteger)day
                     hour:(NSInteger)hour
                   minute:(NSInteger)minute
                   second:(NSInteger)second;

+ (NSInteger)daysOfMonth:(NSInteger)month ofYear:(NSInteger)year;
+ (NSInteger)daysOfMonth:(NSInteger)month;     //默认今年

//字符串转NSDate
+ (NSDate *)dateWithString:(NSString *)dateString;
//
+ (NSDate *)dateWithString2:(NSString *)dateString;

//返回格式： yyyy/MM/dd HH:mm:ss
- (NSString *)dateTimeString;

//返回格式： yyyy-MM-dd HH:mm:ss
- (NSString *)dateTimeString2;

//返回格式： yyyy-MM-dd
-(NSString *)dateTimeString3;

//返回格式：yyyy-MM-dd HH:mm
-(NSString *)dateTimeString4;

//返回格式：yyyy/MM/dd
- (NSString *)dateString;

//返回格式：HH:mm:ss
- (NSString *)timeString1;

///返回格式：HH:mm
- (NSString *)timeString2;


//执行次数计算
+ (NSUInteger)executeTimesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate type:(MBExecuteType)type;

////////////////////////////////////////////////////////////////////////////////////////////////////
// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isLeapYear;
- (BOOL) isTomorrow;

+ (NSDate *) tomorrow;
+ (NSDate *) yesterday;

//Roles
- (BOOL) isTypicallyWeekend;
- (BOOL) isTypicallyWorkday;

- (NSString *)stringFromWeekday;

@end
