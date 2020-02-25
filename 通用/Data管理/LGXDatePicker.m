//
//  LGXDatePicker.m
//
//
//  Created by icash on 15-8-11.
//  Copyright (c) 2015年 iCash. All rights reserved.
//

#import "LGXDatePicker.h"
#import "NSDate+DateTools.h"
#import "LGXHudManager.h"

@interface LGXDatePicker ()
{
    NSTimeZone *_timeZone;
    NSLocale *_locale;
}
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation LGXDatePicker
@synthesize date = _date;

+ (LGXDatePicker *)sharedInstance
{
    static LGXDatePicker *_picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _picker = [[LGXDatePicker alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 216)];
    });
    return _picker;
}

- (void)awakeFromNib
{
    [self doSetup];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}
- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:self.bounds];
    }
    return _datePicker;
}
- (void)doSetup
{
    self.backgroundColor = UIColorClearColor;
    
    [self addSubview:self.datePicker];
    /// 设定
    [NSLocale autoupdatingCurrentLocale];
    _timeZone = [NSTimeZone defaultTimeZone];
    _locale = [NSLocale currentLocale]; // 用这个才对嘛
    self.datePicker.locale = _locale; // 这是用户设定的本地
    self.datePicker.timeZone = _timeZone; // 默认时区,系统时区
    self.maximumDate = [NSDate date];
    self.datePickerMode = LGXDatePickerModeDate;
    
    [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
}

- (void)setDatePickerMode:(LGXDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    UIDatePickerMode pickerModel = UIDatePickerModeDate;
    
    switch (_datePickerMode) {
        case LGXDatePickerModeDate:
            pickerModel = UIDatePickerModeDate;
            break;
        case LGXDatePickerModeDateAndTime:
            pickerModel = UIDatePickerModeDateAndTime;
            break;
        case LGXDatePickerModeTime:
            pickerModel = UIDatePickerModeTime;
            break;
        default:
            break;
    }
    self.datePicker.datePickerMode = pickerModel;
}
- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = _minimumDate;
}
- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = _maximumDate;
}
/// like 1900-01-01 00:00:00 -0500
- (void)setMinimumDateWithString:(NSString *)str
{
    
}
/// like 1900-01-01 00:00:00 -0500
- (void)setMaximumDateWithString:(NSString *)str
{
    
}
- (void)setDate:(NSDate *)date
{
    _date = date;
    if (_date == nil) {
        _date = [NSDate date];
    }
    self.datePicker.date = _date;
}
- (NSDate *)date
{
    return self.datePicker.date;
}
#pragma mark - 时间改变了
- (void)dateChange:(id)sender
{
    NSDate *now = [NSDate date];
    if ([self.date isLaterThan:now]) { // 如果大于当前时间
        self.maximumDate = now;
        self.date = now;
        [_kHUDManager showToastInView:nil atPosition:JGProgressHUDPositionCenter withTitle:@"不能超过今天" hideAfter:_kHUDDefaultHideTime onHide:nil];
        return;
    }
    if (self.dateChangedBlock) {
        self.dateChangedBlock(self.date);
    }
}

#pragma mark - 一些转换方法
/// 获取当前时间戳
- (NSTimeInterval)currentTimeInterval
{
    NSDate *date = [self currentDate];
    NSTimeInterval currentTimeInterval = (int)[date timeIntervalSince1970];

    return currentTimeInterval;
}
/// 获取某个日期的时间戳
- (NSTimeInterval)timeIntervalWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [self currentDate];
    }
    NSTimeInterval timeInterval = (int)[date timeIntervalSince1970];
    return timeInterval;
}
/// 转换某个时间戳到字符串
- (NSString *)timeIntervalStringWithDate:(NSDate *)date
{
    NSTimeInterval timeInterval = [self timeIntervalWithDate:date];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return str;
}
/// 时间戳转date
- (NSDate *)dateTranslateFromTimeInterval:(NSString *)timeInterval
{
    if (timeInterval == nil || [timeInterval isEqual:@""]) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]];
    return date;
}
/**
 * 时间戳转string
 * formatString: 格式，如:@"yyyy年MM月dd日 HH:mm" ,默认是 @"MM-dd HH:mm";
 */
- (NSString *)formatString:(NSString *)formatString translateFromTimeInterval:(NSString *)timeInterval
{
    NSDate *date = [self dateTranslateFromTimeInterval:timeInterval];
    if (date == nil) {
        return nil;
    }
    if (formatString == nil) {
        formatString = @"MM-dd HH:mm";
    }
    NSString *str = [date formattedDateWithFormat:formatString timeZone:_timeZone locale:_locale];
//    DLog(@"\n timeInterval=%@转出来是%@ \n",timeInterval,str);
    return str;
}

/// 获取当前时间
- (NSDate *)currentDate
{
    NSDate *currentDate = [NSDate date];
    return currentDate;
}
/// 根据date获取yyyy年MM月dd日的字符串
- (NSString *)dateStringWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [self currentDate];
    }
    NSString *str = [date formattedDateWithFormat:@"yyyy年MM月dd日" timeZone:_timeZone locale:_locale];
//    DLog(@"\n 日期转换成年月日str=%@ \n",str);
    return str;
}
@end










