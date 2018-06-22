//
//  SecondViewController.m
//  CSDatePickerSView
//
//  Created by 曹世鑫 on 2018/6/22.
//  Copyright © 2018年 曹世鑫. All rights reserved.
//

#import "SecondViewController.h"
#import "FBFiltrateView.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FBFiltrateView *filtrateView = [[FBFiltrateView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+44, self.view.frame.size.width, self.view.frame.size.height-([UIApplication sharedApplication].statusBarFrame.size.height+44))];
    //type为0和1不同的筛选条件以及模式
    filtrateView.type = @"1";
    filtrateView.selectedBack = ^(NSString *payType, NSDate *begainTime, NSDate *endTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        //NSDate转NSString
        NSString *begainDateString = [dateFormatter stringFromDate:begainTime];
        NSString *endTimeDateString = [dateFormatter stringFromDate:endTime];
        NSLog(@"》〉》〉》〉》%@///////////%@>>>>>>>>>>>>>>%@",payType,begainDateString,endTimeDateString);
    };
    [self.view addSubview:filtrateView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
