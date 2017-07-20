//
//  ViewController.m
//  XYDatePicker
//
//  Created by sqyc on 2017/7/20.
//  Copyright © 2017年 sqyc. All rights reserved.
//

#import "ViewController.h"

#import "SQDatePickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapOnButton:(id)sender {
    SQDatePickerView *view = [SQDatePickerView datePickerView];
    
    [view showDatePickerViewWithSelectDate:[NSDate date]];
}

@end
