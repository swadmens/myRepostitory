//
//  LGXDatePicker.h
//
//
//  Created by icash on 15-8-11.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTools.h"

typedef NS_ENUM(NSInteger, LGXDatePickerMode) {
    LGXDatePickerModeTime,           // 显时时分，上上午还是下午(e.g. 6 | 53 | PM)
    LGXDatePickerModeDate,           // 显示年月日 (e.g. November | 15 | 2007)
    LGXDatePickerModeDateAndTime,    // 显示年月日时分 (e.g. Wed Nov 15 | 6 | 53 | PM)
};

#define _kDatePicker [LGXDatePicker sharedInstance]

@interface LGXDatePicker : UIView

+ (LGXDatePicker *)sharedInstance;
/// 显示模式，默认是LGXDatePickerModeDate
@property (nonatomic) LGXDatePickerMode datePickerMode;

/// 最小时间 默认
@property (nonatomic, retain) NSDate *minimumDate;
/// like 1900-01-01 00:00:00 -0500
- (void)setMinimumDateWithString:(NSString *)str;
/// 最大时间 默认是当前时间
@property (nonatomic, retain) NSDate *maximumDate;
/// like 1900-01-01 00:00:00 -0500
- (void)setMaximumDateWithString:(NSString *)str;
/// 当前时间 , 默认是当前时间
@property (nonatomic, retain) NSDate *date;
/// 选择后
@property (nonatomic, copy) void(^dateChangedBlock)(NSDate *date);
#pragma mark - 转换
/*=====================NSTimeInterval=================*/
/// 获取当前时间戳
- (NSTimeInterval)currentTimeInterval;
/// 获取某个日期的时间戳
- (NSTimeInterval)timeIntervalWithDate:(NSDate *)date;
/// 转换某个时间戳到字符串
- (NSString *)timeIntervalStringWithDate:(NSDate *)date;
/// 时间戳转date
- (NSDate *)dateTranslateFromTimeInterval:(NSString *)timeInterval;
/**
 * 时间戳转string
 * formatString: 格式，如:@"yyyy年MM月dd日 HH:mm" ,默认是 @"MM-dd HH:mm";
 */
- (NSString *)formatString:(NSString *)formatString translateFromTimeInterval:(NSString *)timeInterval;
/*=====================NSDate=================*/
/// 获取当前时间
- (NSDate *)currentDate;
/// 根据date获取yyyy年MM月dd日的字符串,date为nil时是当前时间
- (NSString *)dateStringWithDate:(NSDate *)date;

@end
