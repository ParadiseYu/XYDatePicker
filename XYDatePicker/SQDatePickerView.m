//
//  SQDatePickerView.m
//  SQTaxi
//
//  Created by Huang Yanan on 16/8/10.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

#import "SQDatePickerView.h"

#import "NSDateUtilities.h"

#import <YYKit/NSDate+YYAdd.h>
#import <YYKit/NSArray+YYAdd.h>
#import <YYKit/YYCGUtilities.h>

#define PICKERVIEW_HEIGHT (kScreenHeight)/3.0
#define INDEX(array, index) [array objectOrNilAtIndex:index]


@interface SQDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSDate *minDate;//最小日期
@property (nonatomic, strong) NSDate *selectDate;//当前选择的日期
@property (nonatomic, strong) UIView *maskView;//蒙版
@property (nonatomic, copy) NSString *dateStr;//对外输出的时间文本
@property (nonatomic, assign) NSInteger selectedDateRange;//服务端返回的最大天数范围

@property (nonatomic, strong) NSMutableArray *displayDayArr;//天dataSource

@property (nonatomic, copy) NSArray *hourArr;//小时原始数据
@property (nonatomic, strong) NSMutableArray *displayHourArr;//小时dataSource

@property (nonatomic, copy) NSArray *minuteArr;//分钟原始数据
@property (nonatomic, strong) NSMutableArray *displayMinuteArr;//分dataSource

@end

@implementation SQDatePickerView

#pragma mark - 初始化

+ (SQDatePickerView *)datePickerView {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[SQDatePickerView class]]) {
            return obj;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 数据源初始化
    self.displayDayArr = @[@"今天", @"明天", [[[NSDate date] dateByAddingDays:2] stringWithFormat:@"MM月dd日"]].mutableCopy;
    self.hourArr = @[@"00点", @"01点", @"02点", @"03点", @"04点", @"05点", @"06点", @"07点", @"08点", @"09点", @"10点", @"11点", @"12点", @"13点", @"14点", @"15点", @"16点", @"17点", @"18点", @"19点", @"20点", @"21点", @"22点", @"23点"];
    self.minuteArr = @[@"00分", @"05分", @"10分", @"15分", @"20分", @"25分", @"30分", @"35分", @"40分", @"45分", @"50分", @"55分"];
    
    self.selectDate = [NSDate date];
    
    // UI组件初始化
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, PICKERVIEW_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.maskView.hidden = YES;
    
    // 添加退出手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskView addGestureRecognizer:tap];
    
    // 设置代理刷新界面
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    // 网络请求最大天数范围
    self.selectedDateRange = 3;
}

#pragma mark - setter and getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    }
    return _maskView;
}

#pragma mark - Action

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, PICKERVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            self.maskView.hidden = YES;
        }
    }];
}

- (IBAction)cancleAction:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)confirmAction:(UIButton *)sender {
    [self dismiss];
    if (self.selectedDateBlock) {
        [self updateDateStr:self.selectDate];
        self.selectedDateBlock(self.dateStr, self.selectDate);
    }
}

- (void)tapAction {
    [self dismiss];
}

#pragma mark - 功能方法

- (void)updateDateStr:(NSDate *)selectedDate {
    NSString *dateStr = @"今天";
    if ([selectedDate isToday]) {
        dateStr = [NSString stringWithFormat:@"今天 %@",[selectedDate timeString2]];
    } else if ([selectedDate isTomorrow]) {
        dateStr = [NSString stringWithFormat:@"明天 %@",[selectedDate timeString2]];
    } else {
        dateStr = [selectedDate dateTimeString2];
    }
    
    if (dateStr) {
        self.dateStr = dateStr;
    }
}

- (void)showDatePickerViewWithSelectDate:(NSDate *)date {
    self.maskView.hidden = NO;
    self.selectDate = date ? date : [NSDate date];
    [self updateAllDate];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, kScreenHeight - PICKERVIEW_HEIGHT, kScreenWidth, PICKERVIEW_HEIGHT);
    }];
}

- (void)updateAllDate {
    // 设置重要属性：minDate、selectDate
    self.minDate = [SQDatePickerView calculateMinDate];
    if (self.selectDate < self.minDate) {
        self.selectDate = self.minDate;
    } else if (self.selectDate > [self.minDate dateByAddingDays:self.selectedDateRange]) {
        self.selectDate = self.minDate;
    }
    
    // 设置各个列的数据源
    self.displayDayArr = [NSMutableArray array];
    for (int i = 0; i < self.selectedDateRange; i++) {
        NSDate *aDate = [self.minDate dateByAddingDays:i];
        if ([aDate isToday]) {
            [self.displayDayArr addObject:@"今天"];
        } else if ([aDate isTomorrow]) {
            [self.displayDayArr addObject:[NSString stringWithFormat:@"明天 %@", [aDate stringFromWeekday]]];
        } else {
            [self.displayDayArr addObject:[aDate stringWithFormat:[NSString stringWithFormat:@"MM月dd日 %@", [aDate stringFromWeekday]]]];
        }
    }
    
    if (self.selectDate.day == self.minDate.day) {
        self.displayHourArr = [self.hourArr subarrayWithRange:NSMakeRange(self.minDate.hour, 24 - self.minDate.hour)].mutableCopy;
        self.displayMinuteArr = [self.minuteArr subarrayWithRange:NSMakeRange(self.minDate.minute / 5, 12 - self.minDate.minute / 5)].mutableCopy;
    } else {
        self.displayHourArr = self.hourArr.mutableCopy;
        self.displayMinuteArr = self.minuteArr.mutableCopy;
    }
    
    // 刷新界面
    [self.pickerView reloadAllComponents];
    
    // 选中相应的row
    [self.pickerView selectRow:self.selectDate.day - self.minDate.day inComponent:0 animated:NO];
    if (self.selectDate.day == self.minDate.day) {
        [self.pickerView selectRow:self.selectDate.hour - self.minDate.hour inComponent:1 animated:NO];
        [self.pickerView selectRow:(self.selectDate.minute - self.minDate.minute) / 5 inComponent:2 animated:NO];
    } else {
        [self.pickerView selectRow:self.selectDate.hour inComponent:1 animated:NO];
        [self.pickerView selectRow:self.selectDate.minute / 5 inComponent:2 animated:NO];
    }
}

+ (NSDate *)calculateMinDate {
    NSDate *aDate = [[NSDate date] dateByAddingMinutes:30];
    NSDateComponents *comp = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    comp.minute = (((int)(aDate.minute / 5) + 1) % 12) * 5;
    comp.hour = comp.minute == 0 ? (aDate.hour + 1) % 24 : aDate.hour;
    comp.day = (comp.minute == 0 && ((aDate.hour + 1) % 24 == 0)) ? aDate.day + 1 : aDate.day;
    return [CURRENT_CALENDAR dateFromComponents:comp];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.displayDayArr.count;
    } else if (component == 1) {
        return self.displayHourArr.count;
    } else {
        return self.displayMinuteArr.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return kScreenWidth / 2.f;
            break;
        default:
            return kScreenWidth / 4.f;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return INDEX(self.displayDayArr, row);
    } else if (component == 1) {
        return INDEX(self.displayHourArr, row);
    } else {
        return INDEX(self.displayMinuteArr, row);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger index0 = [pickerView selectedRowInComponent:0];
    NSInteger index1 = [pickerView selectedRowInComponent:1];
    NSInteger index2 = [pickerView selectedRowInComponent:2];
    
    NSDate *chosenDate = [NSDate dateWithTimeInterval:index0 * 24 * 60 * 60 sinceDate:self.minDate];
    NSDateComponents *comp = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:chosenDate];
    comp.hour = [self.hourArr indexOfObject:INDEX(self.displayHourArr, index1)];
    comp.minute = [self.minuteArr indexOfObject:INDEX(self.displayMinuteArr, index2)] * 5;
    
    self.selectDate = [CURRENT_CALENDAR dateFromComponents:comp];
    [self updateAllDate];
}

@end
