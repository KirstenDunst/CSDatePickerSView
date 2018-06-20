//
//  ViewController.m
//  CSDatePickerSView
//
//  Created by 曹世鑫 on 2018/6/20.
//  Copyright © 2018年 曹世鑫. All rights reserved.
//

#import "ViewController.h"
#import "CSDatePickerSView.h"

@interface ViewController ()<CSDatePickerSViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(80, 100, 100, 60);
    [button setTitle:@"你好" forState:UIControlStateNormal];
    [button setTintColor:[UIColor cyanColor]];
    [button addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
- (void)buttonChoose:(UIButton *)sender{
    CSDatePickerSView *pickerView = [[CSDatePickerSView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height,self.view.frame.size.width,260)];
//    pickerView.datePickerViewDateRangeModel = CSDatePickerViewDateRangeModelCustom;
//    pickerView.minYear = 1998;
//    pickerView.maxYear = 2008;
    pickerView.datePickerViewShowModel = CSDatePickerViewShowModelDefalut;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    [pickerView show];
}

//实现代理函数
- (void)datePickerView:(UIPickerView *)datePickerView didSelectDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    NSLog(@"》〉》〉》〉》%@///////////%@",date,currentDateString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
