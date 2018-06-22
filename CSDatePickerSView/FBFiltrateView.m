//
//  FBFiltrateView.m
//  FSFuBei
//
//  Created by 曹世鑫 on 2018/6/11.
//  Copyright © 2018年 曹世鑫. All rights reserved.
//

#import "FBFiltrateView.h"
#import "ICMacro.h"
#import "FBFiltrateModel.h"
#import "CSDatePickerSView.h"

//时间选择
typedef enum:NSInteger{
    timeChooseTags = 100,
    payTypeTags = 200,
    chooseBtnTags = 300,
}TimeTags;

@interface FBFiltrateView()<CSDatePickerSViewDelegate>

//是否是单选
@property (nonatomic, assign)BOOL isMultipleChoose;
//选中的button
@property (nonatomic, strong)UIButton *selectBtn;
//标题的label
@property (nonatomic, strong)UILabel *titleLabel;
//时间选择的标题
@property (nonatomic, strong)UILabel *subLabel;
//提示的标题信息
@property (nonatomic, strong)UILabel *alarmLabel;
//内部包含所有的button按钮
@property (nonatomic, strong)NSMutableArray *selectPayTypeArr;
//数据源包含model
@property (nonatomic, strong)NSMutableArray *dataSourecArr;
//记录点击的时间btn
@property (nonatomic, strong)UIButton *timeBtnSelect;
//时间选择器
@property (nonatomic, strong)CSDatePickerSView *datePickerView;
//记录是否是年月日显示还是时分秒显示
@property (nonatomic, assign)BOOL isNYRTemp;
@end

@implementation FBFiltrateView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self.frame = frame;
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(10*SCALE, 0, 80*SCALE, 40*SCALE);
    self.titleLabel.text = @"付款方式";
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.font = FONT_OF_SIZE(13);
    [self addSubview:self.titleLabel];
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.frame = CGRectMake(10*SCALE, CGRectGetMaxY(self.titleLabel.frame)+40*SCALE, 80*SCALE, 40*SCALE);
    self.subLabel.text = @"选择时间";
    self.subLabel.textColor = [UIColor lightGrayColor];
    self.subLabel.font = FONT_OF_SIZE(13);
    [self addSubview:self.subLabel];
    
    UILabel *timeBegainLabel = [[UILabel alloc] init];
    timeBegainLabel.frame = CGRectMake(30*SCALE, CGRectGetMaxY(self.subLabel.frame), 80*SCALE, 40*SCALE);
    timeBegainLabel.text = @"开始时间";
    timeBegainLabel.textColor = [UIColor lightGrayColor];
    timeBegainLabel.font = FONT_OF_SIZE(13);
    [self addSubview:timeBegainLabel];
    UILabel *timeEndLabel = [[UILabel alloc] init];
    timeEndLabel.frame = CGRectMake(CGRectGetMinX(timeBegainLabel.frame), CGRectGetMaxY(timeBegainLabel.frame), 80*SCALE, 40*SCALE);
    timeEndLabel.text = @"结束时间";
    timeEndLabel.textColor = [UIColor lightGrayColor];
    timeEndLabel.font = FONT_OF_SIZE(13);
    [self addSubview:timeEndLabel];
    
    self.alarmLabel = [[UILabel alloc] init];
    self.alarmLabel.frame = CGRectMake(10*SCALE, CGRectGetMaxY(timeEndLabel.frame), W_WIDTH-20*SCALE, 40*SCALE);
    self.alarmLabel.text = @"三个月前数据请登录商户后台查看";
    self.alarmLabel.textColor = [UIColor lightGrayColor];
    self.alarmLabel.font = FONT_OF_SIZE(13);
    [self addSubview:self.alarmLabel];
    
    float btnWidth = 90*SCALE;
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat indexWidth = (W_WIDTH-CGRectGetMaxX(timeBegainLabel.frame)-btnWidth*2*SCALE-10*SCALE)/3+btnWidth*SCALE;
        button.frame = CGRectMake(CGRectGetMaxX(timeBegainLabel.frame)+indexWidth*(i%2), CGRectGetMinY(timeBegainLabel.frame)+5+(timeBegainLabel.frame.size.height)*(i/2), btnWidth*SCALE, 30*SCALE);
        [button setTitle:[self dateWithIsHourMinutesSecond:i%2] forState:UIControlStateNormal];
        [button setTintColor:[UIColor lightGrayColor]];
        button.tag = timeChooseTags+i;
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    NSArray *titleArr = @[@"重制",@"确认"].copy;
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10*SCALE+W_WIDTH/2*i, self.frame.size.height-100*SCALE, W_WIDTH/2-20*SCALE, 50*SCALE);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTintColor:[UIColor blackColor]];
            [button setBackgroundColor:[UIColor whiteColor]];
        }else{
            [button setTintColor:[UIColor whiteColor]];
            [button setBackgroundColor:[UIColor redColor]];
        }
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:18*SCALE];
        button.tag = chooseBtnTags+i;
        [button addTarget:self action:@selector(resultChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    //点击隐藏时间选择器
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissDatePick:)];
    [self addGestureRecognizer:tap];
}
- (void)dismissDatePick:(UIGestureRecognizer *)tapSender{
    [self.datePickerView close];
}

//重制，确认按钮
- (void)resultChoose:(UIButton *)sender{
    if (sender.tag-chooseBtnTags == 0) {//重制事件
        for (int i = 0; i < self.dataSourecArr.count; i++) {
            FBFiltrateModel *model = self.dataSourecArr[i];
            UIButton *tempBtn = [self viewWithTag:payTypeTags+i];
            static UIColor *colorNow;
            if (i == 0) {
                model.isSelct = YES;
                if (self.isMultipleChoose) {
                    self.selectBtn = tempBtn;
                }
                colorNow = [UIColor redColor];
                [tempBtn setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
            } else {
                model.isSelct = NO;
                colorNow = [UIColor lightGrayColor];
                [tempBtn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            [tempBtn setTintColor:colorNow];
            tempBtn.layer.borderColor = colorNow.CGColor;
        }
        //这里还要把时间都重置回来
        for (int i = 0; i < 4; i++) {
            UIButton *tempBtn = [self viewWithTag:timeChooseTags+i];
            [tempBtn setTitle:[self dateStrWithNYR:i%2] forState:UIControlStateNormal];
        }
    } else {//确认事件
       //这里可以根据pay数组里面是否有选中的以及当前的单选状态决定来返回
        static BOOL isPayTypeChoosed; NSDate *begainTime,*endTime;NSString *payTypeStr;
        for (int i = 0; i < 2; i++) {
            //这里将时间拼接转化合成
            UIButton *tempBtnOne = [self viewWithTag:timeChooseTags+i*2];
            UIButton *tempBtnTwo = [self viewWithTag:timeChooseTags+i*2+1];
            if (i == 0) {
                begainTime = [self dateWithString:[NSString stringWithFormat:@"%@ %@",tempBtnOne.titleLabel.text,tempBtnTwo.titleLabel.text]];
            }else{
                endTime = [self dateWithString:[NSString stringWithFormat:@"%@ %@",tempBtnOne.titleLabel.text,tempBtnTwo.titleLabel.text]];
            }
        }
        
        isPayTypeChoosed = NO;
        payTypeStr = nil;
        for (FBFiltrateModel *model in self.dataSourecArr) {
            if (model.isSelct) {
                isPayTypeChoosed = YES;
            }
        }
        if (isPayTypeChoosed) {
            if (self.isMultipleChoose) {
                if (self.selectBtn.tag-payTypeTags == 0) {
                    //今天(这里都是到当前时间)
                    begainTime = [self BegainDateWithDate:[NSDate date]];
                    endTime = [NSDate date];
                }else if (self.selectBtn.tag-payTypeTags == 1){
                    //最近七天
                    begainTime = [self SevenDateSiceNow];
                    endTime = [NSDate date];
                }
            }else{
                for (FBFiltrateModel *model in self.dataSourecArr) {
                    if (model.isSelct) {
                        if (payTypeStr == nil) {
                            payTypeStr = model.titleStr;
                        }else{
                            payTypeStr = [NSString stringWithFormat:@"%@,%@",payTypeStr,model.titleStr];
                        }
                    }
                }
            }
        }
        if (self.selectedBack) {
            self.selectedBack(payTypeStr, begainTime, endTime);
        }
    }
    //时间选择隐藏
    [self.datePickerView close];
}
//获取最近七天时间
- (NSDate *)SevenDateSiceNow{
    NSDate *sevenLastDay = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:[NSDate date]];
    return [self BegainDateWithDate:sevenLastDay];
}
// 当天的最早时间
- (NSDate *)BegainDateWithDate:(NSDate *)date{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    currentDateString = [currentDateString stringByAppendingString:@" 00:00:00"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *resDate = [formatter1 dateFromString:currentDateString];
    return resDate;
}
//date转字符串(日期和时间)
- (NSString *)dateStrWithNYR:(BOOL)isNYR{
    NSDate *tempDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式
    if (!isNYR) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:tempDate];
    return currentDateString;
}

//字符串转date
- (NSDate *)dateWithString:(NSString *)dateStr{
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *resDate = [formatter1 dateFromString:dateStr];
    return resDate;
}
//时间选择
- (void)buttonChoose:(UIButton *)sender{
    if (self.isMultipleChoose) {
        [self.selectBtn setTintColor:[UIColor lightGrayColor]];
        self.selectBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
        FBFiltrateModel *oldModel = self.dataSourecArr[self.selectBtn.tag-payTypeTags];
        oldModel.isSelct = NO;
    }
    //isNYEtemp用来区分 是否是年月日显示，  isNewTime用来显示是否是新的一行的时间记录
    static BOOL isNYEtemp,isNewTime;
    if ((sender.tag-timeChooseTags)%2 == 0) {
        isNYEtemp = YES;
    }else{
        isNYEtemp = NO;
    }
    
    if ((sender.tag-timeChooseTags)/2 == (self.timeBtnSelect.tag-timeChooseTags)/2) {
        isNewTime = NO;
    }else{
        isNewTime = YES;
    }
    self.timeBtnSelect = sender;
    [self buttonChooseWithType:isNYEtemp WithReset:isNewTime];
}

- (NSString *)dateWithIsHourMinutesSecond:(BOOL)isHMS{
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    if (isHMS) {
        format.dateFormat = @"HH:mm:ss";
    }else{
        format.dateFormat = @"yyyy-MM-dd";
    }
    return [format stringFromDate:date];
}
- (void)setType:(NSString *)type{
    //这里测试
    if ([type isEqualToString:@"1"]) {
        self.isMultipleChoose = NO;
    }else{
        self.isMultipleChoose = YES;
    }
    [self initDataSourceWithType:type];
    
    [self createPayTypeWithArr:self.dataSourecArr];
}
- (void)initDataSourceWithType:(NSString *)type{
    [self.dataSourecArr removeAllObjects];
    switch ([type intValue]) {
        case 0:
        {
            NSArray *arr = @[@"今天",@"最近七天"].copy;
            for (int i = 0; i< arr.count; i++) {
                FBFiltrateModel *model = [[FBFiltrateModel alloc]init];
                if (i == 0) {
                    model.isSelct = YES;
                }else{
                    model.isSelct = NO;
                }
                model.titleStr = arr[i];
                model.payType = [NSString stringWithFormat:@"%d",i];
                [self.dataSourecArr addObject:model];
            }
        }
            break;
        case 1:
        {
            NSArray *arr = @[@"全部",@"微信",@"支付宝",@"京东钱包"].copy;
            for (int i = 0; i< arr.count; i++) {
                FBFiltrateModel *model = [[FBFiltrateModel alloc]init];
                if (i == 0) {
                    model.isSelct = YES;
                }else{
                    model.isSelct = NO;
                }
                model.titleStr = arr[i];
                model.payType = [NSString stringWithFormat:@"%d",i];
                [self.dataSourecArr addObject:model];
            }
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}
- (void)createPayTypeWithArr:(NSArray *)tempArr{
    for (int i = 0; i<tempArr.count; i++) {
        FBFiltrateModel *model = tempArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10*SCALE+(W_WIDTH-20*SCALE)/tempArr.count*i, CGRectGetMaxY(self.titleLabel.frame)+5, (W_WIDTH-20*SCALE)/tempArr.count-10*SCALE, 30*SCALE);
        [button setTitle:model.titleStr forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1;
        [button setBackgroundColor:[UIColor whiteColor]];
        static UIColor *colorNow;
        if (model.isSelct) {
            if (self.isMultipleChoose) {
                self.selectBtn = button;
            }
            colorNow = [UIColor redColor];
            [button setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
        }else{
            colorNow = [UIColor lightGrayColor];
        }
        [button setTintColor:colorNow];
        button.tag = payTypeTags+i;
        button.layer.borderColor = colorNow.CGColor;
        [button addTarget:self action:@selector(payTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.selectPayTypeArr addObject:button];
    }
}
//整个界面的多选还是单选
//多选处理逻辑：当后面的全选的时候或者是一个不选的时候会选中全选，其他的为不选状态。（确定的时候可以根据总数据源dataSourecArr选中状态来进一步处理）
//单选处理逻辑：整个界面主要是时间的选择，上面的和下面的自定义时间唯一。
- (void)payTypeSelect:(UIButton *)sender{
    //隐藏时间选择
    [self.datePickerView close];
    
    if (self.isMultipleChoose) {
        [self.selectBtn setTintColor:[UIColor lightGrayColor]];
        self.selectBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
        FBFiltrateModel *oldModel = self.dataSourecArr[self.selectBtn.tag-payTypeTags];
        oldModel.isSelct = NO;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
        [sender setTintColor:[UIColor redColor]];
        sender.layer.borderColor = [UIColor redColor].CGColor;
        FBFiltrateModel *model = self.dataSourecArr[sender.tag-payTypeTags];
        model.isSelct = YES;
        
        self.selectBtn = sender;
    }else{
        if ((sender.tag-payTypeTags) == 0) {
            for (int i = 0; i<self.selectPayTypeArr.count; i++) {
                UIButton *tempBtn = self.selectPayTypeArr[i];
                FBFiltrateModel *model = self.dataSourecArr[i];
                if (i == 0) {
                    model.isSelct = YES;
                    [sender setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
                    [sender setTintColor:[UIColor redColor]];
                    sender.layer.borderColor = [UIColor redColor].CGColor;
                }else{
                    model.isSelct = NO;
                    [tempBtn setTintColor:[UIColor lightGrayColor]];
                    tempBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    [tempBtn setBackgroundImage:nil forState:UIControlStateNormal];
                }
            }
        }else{
            FBFiltrateModel *model = self.dataSourecArr[sender.tag-payTypeTags];
            model.isSelct = !model.isSelct;
            if (model.isSelct) {
                [sender setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
                [sender setTintColor:[UIColor redColor]];
                sender.layer.borderColor = [UIColor redColor].CGColor;
            }else{
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setTintColor:[UIColor lightGrayColor]];
                sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
            
            long chooseCount = self.dataSourecArr.count-1;
            for (int i = 1; i<self.dataSourecArr.count; i++) {
                FBFiltrateModel *model = self.dataSourecArr[i];
                if (!model.isSelct) {
                    chooseCount--;
                }
            }
            if (chooseCount == 0 ||chooseCount == self.dataSourecArr.count-1) {
                for (int i = 0; i<self.selectPayTypeArr.count;i++) {
                    UIButton *tempBtn = self.selectPayTypeArr[i];
                    FBFiltrateModel *model = self.dataSourecArr[i];
                    if (i == 0) {
                        model.isSelct = YES;
                        [tempBtn setTintColor:[UIColor redColor]];
                        tempBtn.layer.borderColor = [UIColor redColor].CGColor;
                        [tempBtn setBackgroundImage:[UIImage imageNamed:@"filter_selected"] forState:UIControlStateNormal];
                    }else{
                        model.isSelct = NO;
                        [tempBtn setTintColor:[UIColor lightGrayColor]];
                        tempBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        [tempBtn setBackgroundImage:nil forState:UIControlStateNormal];
                    }
                }
            }else{
                FBFiltrateModel *model = self.dataSourecArr[0];
                model.isSelct = NO;
                UIButton *tempBtn = self.selectPayTypeArr[0];
                [tempBtn setBackgroundImage:nil forState:UIControlStateNormal];
                [tempBtn setTintColor:[UIColor lightGrayColor]];
                tempBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }
    }
}
#pragma mark ----------日期选择切换样式的处理方法
- (void)buttonChooseWithType:(BOOL)isNYR WithReset:(BOOL)isReset{
    if (isReset) {
        [self.datePickerView reloadDataNew];
    }
    self.isNYRTemp = isNYR;
    if (isNYR) {
        self.datePickerView.datePickerViewShowModel = CSDatePickerViewShowModelYearMonthDay;
    }else{
        self.datePickerView.datePickerViewShowModel = CSDatePickerViewShowModelHourMintueSecond;
    }
    [self.datePickerView show];
}
#pragma mark ----------CSDatePickerSViewDelegate的代理方法
- (void)datePickerView:(UIPickerView *)datePickerView didSelectDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    if (self.isNYRTemp) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    NSLog(@"》〉》〉》〉》%@///////////%@",date,currentDateString);
    [self.timeBtnSelect setTitle:currentDateString forState:UIControlStateNormal];
}
#pragma mark ----------- 懒加载
- (CSDatePickerSView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[CSDatePickerSView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 246.0)];
        _datePickerView.delegate = self;
        [self addSubview:self.datePickerView];
    }
    return _datePickerView;
}

- (NSMutableArray *)selectPayTypeArr{
    if (!_selectPayTypeArr) {
        _selectPayTypeArr = [NSMutableArray array];
    }
    return _selectPayTypeArr;
}
- (NSMutableArray *)dataSourecArr{
    if (!_dataSourecArr) {
        _dataSourecArr = [NSMutableArray array];
    }
    return _dataSourecArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
