//
//  SQDatePickerView.h
//  SQTaxi
//
//  Created by Huang Yanan on 16/8/10.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQDatePickerView : UIView

@property (nonatomic, copy) void (^selectedDateBlock)(NSString *selectedDate, NSDate *date);///<当前选择的日期的回调

+ (SQDatePickerView *)datePickerView;///<初始化

+ (NSDate *)calculateMinDate;///<对外提供计算最小时间的方法

- (void)showDatePickerViewWithSelectDate:(NSDate *)date;///<显示

@end
