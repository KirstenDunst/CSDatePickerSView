//
//  CSDatePickerSView.m
//  CSDatePickerSView
//
//  Created by 曹世鑫 on 2018/6/20.
//  Copyright © 2018年 曹世鑫. All rights reserved.
//

#import "CSDatePickerSView.h"

@interface CSDatePickerSView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    //数据源。
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    NSMutableArray *secondArray;
    
    //最大值。
    NSInteger maxMonth;
    NSInteger maxDay;
    NSInteger maxHour;
    NSInteger maxMinute;
    NSInteger maxSecond;
    
    //选中行数。
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    NSInteger selectedHourRow;
    NSInteger selectedMinuteRow;
    NSInteger selectedSecondRow;
    
    //总标题数。
    NSInteger totalTitleLabel;
    UIView *_topView;
    //选中当前行，用来控制文字颜色显示。
    NSInteger selectRow;
}
//时间选择view
@property (nonatomic, strong) UIPickerView *datePickerView;
//总的数据源
@property (nonatomic, strong) NSMutableArray *dataArr;
//目前显示的类型的所有选中row的依次集合。
@property (nonatomic, strong) NSMutableArray *selectRowArr;
//显示的标题arr
@property (nonatomic, strong) NSMutableArray *titleArr;

@end

@implementation CSDatePickerSView
#define AnimationDuration 0.3
#define BTNCHOOSEVIEWHEIGHT 44
#define TITLESHOWHEIGHT 30

- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)selectRowArr{
    if (!_selectRowArr) {
        _selectRowArr = [NSMutableArray array];
    }
    return _selectRowArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (UIPickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, BTNCHOOSEVIEWHEIGHT+TITLESHOWHEIGHT, self.frame.size.width, self.frame.size.height-(BTNCHOOSEVIEWHEIGHT+TITLESHOWHEIGHT))];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.showsSelectionIndicator = YES;
        _datePickerView.delegate = self;
        _datePickerView.dataSource = self;
    }
    return _datePickerView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _minYear = 1970;
        _datePickerViewShowModel = CSDatePickerViewShowModelDefalut;
        _datePickerViewDateRangeModel = CSDatePickerViewDateRangeModelCurrent;
        [self initArrTemp];
        [self __initView];
        [self __initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self.frame = frame;
    if (self = [super initWithFrame:frame]) {
        _minYear = 1970;
        _datePickerViewShowModel = CSDatePickerViewShowModelDefalut;
        _datePickerViewDateRangeModel = CSDatePickerViewDateRangeModelCurrent;
        [self initArrTemp];
        [self __initView];
        [self __initData];
    }
    return self;
}
- (void)initArrTemp{
    yearArray = [[NSMutableArray alloc]init];
    monthArray = [[NSMutableArray alloc]init];
    dayArray = [[NSMutableArray alloc]init];
    hourArray = [[NSMutableArray alloc]init];
    minuteArray = [[NSMutableArray alloc]init];
    secondArray = [[NSMutableArray alloc]init];
}

- (void)__initView{
    self.backgroundColor = [UIColor whiteColor];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,BTNCHOOSEVIEWHEIGHT)];
    [self addSubview:_topView];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30,8,40, 28)];
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 30 - 40,8,40, 28)];
    [cancelButton setTitle:@"取消"forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定"forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked)forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked)forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:cancelButton];
    [_topView addSubview:confirmButton];
}

- (void)__initData{
    //初始化最大值。
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *currentDateComponents = [calendar components:calendarUnit fromDate:currentDate];
    _maxYear = [currentDateComponents year];
    maxMonth = [currentDateComponents month];
    maxDay = [currentDateComponents day];
    maxHour = [currentDateComponents hour];
    maxMinute = [currentDateComponents minute];
    maxSecond = [currentDateComponents second];
    
    //初始化当前时间。
    NSInteger currentYear = _maxYear;
    NSInteger currentMonth = maxMonth;
    NSInteger currentDay = maxDay;
    NSInteger currentHour = maxHour;
    NSInteger currentMinute = maxMinute;
    NSInteger currentSecond = maxSecond;
    
    //初始化年份数组(范围自定义)。
    for (NSInteger i = _minYear; i <= currentYear; i ++) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    selectedYearRow = [yearArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)currentYear]];
    
    //初始化月份数组(1-12)。
    for (NSInteger i = 1; i <= currentMonth; i++) {
        [monthArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    selectedMonthRow = currentMonth - 1;
    
    //初始化天数数组(1-31)。
    for (NSInteger i = 1; i <= currentDay; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    selectedDayRow = currentDay - 1;
    
    //初始化小时数组(0-23)。
    for (NSInteger i = 0; i <= currentHour; i++) {
        [hourArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    selectedHourRow = currentHour;
    
    //初始化分钟数组(0-59)。
    for (NSInteger i = 0; i <= currentMinute; i++) {
        [minuteArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    selectedMinuteRow = currentMinute;
    
    //初始化秒数组(0-59)。
    for (NSInteger i = 0; i <= currentSecond; i++) {
        [secondArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    selectedSecondRow = currentSecond;
    
}

- (void)reloadDataNew{
    [yearArray removeAllObjects];
    [monthArray removeAllObjects];
    [dayArray removeAllObjects];
    [hourArray removeAllObjects];
    [minuteArray removeAllObjects];
    [secondArray removeAllObjects];
    //    [self __initData];
    [self __initData];
    [self updateCurrentDateArray];
    //    [self choseNowTime];
}

#pragma mark - Setter
- (void)setMinYear:(NSInteger)minYear {
    NSAssert(minYear < _maxYear, @"最小年份必须小于最大年份！");
    _minYear = minYear;
    [self resetYearArray];
    [self.datePickerView reloadAllComponents];
}

- (void)setMaxYear:(NSInteger)maxYear {
    NSAssert(maxYear > _minYear, @"最大年份必须大于最小年份！");
    NSAssert(_datePickerViewDateRangeModel == CSDatePickerViewDateRangeModelCustom, @"当前模式下只允许显示当前系统最大时间，所以不允许设置最大年份！");
    //更新最大值。
    _maxYear = maxYear;
    [self updateCurrentDateArray];
    [self.datePickerView reloadAllComponents];
}

- (void)setDatePickerViewDateRangeModel:(CSDatePickerViewDateRangeModel)datePickerViewDateRangeModel{
    if (_datePickerViewDateRangeModel != datePickerViewDateRangeModel) {
        _datePickerViewDateRangeModel = datePickerViewDateRangeModel;
    }
    if (_datePickerViewDateRangeModel == CSDatePickerViewDateRangeModelCurrent) {
        //更新时间最大值为当前系统时间。
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *currentDateComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
        
        _maxYear = [currentDateComponents year];
        maxMonth = [currentDateComponents month];
        maxDay = [currentDateComponents day];
        maxHour = [currentDateComponents hour];
        maxMinute = [currentDateComponents minute];
        maxSecond = [currentDateComponents second];
        
    }else if (_datePickerViewDateRangeModel == CSDatePickerViewDateRangeModelCustom) {
        //年份不变，其它更新为最大值。
        maxMonth = 12;
        maxDay = 31;
        maxHour = 23;
        maxMinute = 59;
        maxSecond = 59;
    }
    
    [self updateCurrentDateArray];
    [self.datePickerView reloadAllComponents];
}
#pragma mark 更新但前时间数组中的数据
- (void)updateCurrentDateArray {
    //获取当前选中时间。
    NSInteger currentYear = [[yearArray objectAtIndex:selectedYearRow] integerValue];
    NSInteger currentMonth = [[monthArray objectAtIndex:selectedMonthRow] integerValue];
    NSInteger currentDay = [[dayArray objectAtIndex:selectedDayRow] integerValue];
    NSInteger currentHour = [[hourArray objectAtIndex:selectedHourRow] integerValue];
    NSInteger currentMinute = [[minuteArray objectAtIndex:selectedMinuteRow] integerValue];
    
    //更新时间数组中的数据。
    [self resetYearArray];
    [self resetMonthArrayWithYear:currentYear];
    [self resetDayArrayWithYear:currentYear month:currentMonth];
    [self resetHourArrayWithYear:currentYear month:currentMonth day:currentDay];
    [self resetMinuteArrayWithYear:currentYear month:currentMonth day:currentDay hour:currentHour];
    [self resetSecondArrayWithYear:currentYear month:currentMonth day:currentDay hour:currentHour mintues:currentMinute];
}

- (void)setDatePickerViewShowModel:(CSDatePickerViewShowModel)datePickerViewShowModel {
    if (_datePickerViewShowModel!=datePickerViewShowModel) {
        _datePickerViewShowModel = datePickerViewShowModel;
    }
    [self.titleArr removeAllObjects];
    [self.dataArr removeAllObjects];
    [self.selectRowArr removeAllObjects];
    switch (_datePickerViewShowModel) {
        case CSDatePickerViewShowModelDefalut:
        {
            self.titleArr = @[@"年",@"月",@"日",@"时",@"分"].mutableCopy;
            [self.dataArr addObject:yearArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedYearRow]];
            [self.dataArr addObject:monthArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMonthRow]];
            [self.dataArr addObject:dayArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedDayRow]];
            [self.dataArr addObject:hourArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedHourRow]];
            [self.dataArr addObject:minuteArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMinuteRow]];
        }
            break;
        case CSDatePickerViewShowModelYearMonthDay:
        {
            self.titleArr = @[@"年",@"月",@"日"].mutableCopy;
            [self.dataArr addObject:yearArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedYearRow]];
            [self.dataArr addObject:monthArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMonthRow]];
            [self.dataArr addObject:dayArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedDayRow]];
        }
            break;
        case CSDatePickerViewShowModelYearMonthDayHour:
        {
            self.titleArr = @[@"年",@"月",@"日",@"时"].mutableCopy;
            [self.dataArr addObject:yearArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedYearRow]];
            [self.dataArr addObject:monthArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMonthRow]];
            [self.dataArr addObject:dayArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedDayRow]];
            [self.dataArr addObject:hourArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedHourRow]];
        }
            break;
        case CSDatePickerViewShowModelHourMintueSecond:
        {
            self.titleArr = @[@"时",@"分",@"秒"].mutableCopy;
            [self.dataArr addObject:hourArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedHourRow]];
            [self.dataArr addObject:minuteArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMinuteRow]];
            [self.dataArr addObject:secondArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedSecondRow]];
        }
            break;
        case CSDatePickerViewShowModelDefalutSecond:
        {
            self.titleArr = @[@"年",@"月",@"日",@"时",@"分",@"秒"].mutableCopy;
            [self.dataArr addObject:yearArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedYearRow]];
            [self.dataArr addObject:monthArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMonthRow]];
            [self.dataArr addObject:dayArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedDayRow]];
            [self.dataArr addObject:hourArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedHourRow]];
            [self.dataArr addObject:minuteArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedMinuteRow]];
            [self.dataArr addObject:secondArray];
            [self.selectRowArr addObject:[NSNumber numberWithInteger:selectedSecondRow]];
        }
            break;
    }
    for(UIView *view in [self subviews])
    {
        if (view != _topView) {
            [view removeFromSuperview];
        }
    }
    [self addSubview:self.datePickerView];
    [self choseNowTime];
    [self resetTitleShow];
}
- (void)resetTitleShow{
    for (int i = 0; i < self.titleArr.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake((self.frame.size.width/self.titleArr.count)*i, BTNCHOOSEVIEWHEIGHT, (self.frame.size.width/self.titleArr.count), TITLESHOWHEIGHT);
        label.text = self.titleArr[i];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}
//刷新时间并转到当前的最新时间
- (void)choseNowTime{
    //先刷新一下将数组界面置新，防止转到的时候会先刷新展示的row的值导致数组越界崩溃
    [self.datePickerView reloadAllComponents];
    for (int i = 0; i< self.selectRowArr.count; i++) {
        //转到当前的时间值（不能超）
        [self.datePickerView selectRow:[self.selectRowArr[i] integerValue] inComponent:i animated:YES];
    }
}



#pragma mark 重置年份
- (void)resetYearArray{
    //先判断是否需要重置。
    NSInteger minYear = [yearArray[0] integerValue];
    NSInteger maxYear = [yearArray[yearArray.count - 1] integerValue];
    if (_minYear == minYear && _maxYear == maxYear) {
        return;
    }
    [yearArray removeAllObjects];
    for (NSInteger i = _minYear; i <= _maxYear; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    //重置年份选中行，防止越界。
    selectedYearRow = selectedYearRow > [yearArray count] - 1 ? [yearArray count] - 1 : selectedYearRow;
}
#pragma mark 重置月份
- (void)resetMonthArrayWithYear:(NSInteger)year{
    NSInteger totalMonth = 12;
    if (_maxYear == year) {
        totalMonth = maxMonth; //限制月份。
    }
    
    NSInteger lastMonth = [monthArray[monthArray.count - 1] integerValue]; //数组中最大月份。
    if (lastMonth < totalMonth) {
        while (++lastMonth <= totalMonth) {
            [monthArray addObject:[NSString stringWithFormat:@"%ld",(long)lastMonth]];
        }
    }else if (lastMonth > totalMonth) {
        while (lastMonth > totalMonth) {
            [monthArray removeObject:[NSString stringWithFormat:@"%ld",(long)lastMonth]];
            lastMonth--;
        }
    }
    //重置月份选中行，防止越界。
    selectedMonthRow = selectedMonthRow > [monthArray count] - 1 ? [monthArray count] - 1: selectedMonthRow;
}
#pragma mark 重置天数
- (void)resetDayArrayWithYear:(NSInteger)year month:(NSInteger)month {
    NSInteger totalDay = 0;
    if (_maxYear == year && maxMonth == month) {
        totalDay = maxDay; //限制最大天数。
    }else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        totalDay = 31;
    }else if(month == 2){
        if (((year % 4 == 0 && year % 100 != 0 ))|| (year % 400 == 0)) {
            totalDay = 29;
        }else{
            totalDay = 28;
        }
    }else{
        totalDay = 30;
    }
    
    NSInteger lastDay = [dayArray[dayArray.count - 1] integerValue]; //数组中最大天数。
    if(lastDay < totalDay) {
        while (++lastDay <= totalDay) {
            [dayArray addObject:[NSString stringWithFormat:@"%ld",(long)lastDay]];
        }
    }else if (lastDay > totalDay) {
        while (lastDay > totalDay) {
            [dayArray removeObject:[NSString stringWithFormat:@"%ld",(long)lastDay]];
            lastDay--;
        }
    }
    
    //重置天数选中行，防止越界。
    selectedDayRow = selectedDayRow > [dayArray count] - 1 ? [dayArray count] - 1 : selectedDayRow;
}

#pragma mark 重置小时
- (void)resetHourArrayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger totalHour = 23;
    if (_maxYear == year && maxMonth == month && maxDay == day) {
        totalHour = maxHour; //限制小时。
    }
    
    NSInteger lastHour = [hourArray[hourArray.count - 1] integerValue]; //数组中最大小时。
    if (lastHour < totalHour) {
        while (++lastHour <= totalHour) {
            [hourArray addObject:[NSString stringWithFormat:@"%ld",(long)lastHour]];
        }
    }else if (lastHour > totalHour){
        while (lastHour > totalHour) {
            [hourArray removeObject:[NSString stringWithFormat:@"%ld",(long)lastHour]];
            lastHour--;
        }
    }
    
    //重置小时选中行，防止越界。
    selectedHourRow = selectedHourRow > [hourArray count] - 1 ? [hourArray count] - 1 : selectedHourRow;
}

#pragma mark 重置分钟
- (void)resetMinuteArrayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    NSInteger totalMinute = 59;
    if (_maxYear == year && maxMonth == month && maxDay == day && maxHour == hour) {
        totalMinute = maxMinute; //限制分钟。
    }
    
    NSInteger lastMinute = [minuteArray[minuteArray.count - 1] integerValue]; //数组中最大分钟。
    if (lastMinute < totalMinute) {
        while (++lastMinute <= totalMinute) {
            [minuteArray addObject:[NSString stringWithFormat:@"%ld",(long)lastMinute]];
        }
    }else if (lastMinute > totalMinute){
        while (lastMinute > totalMinute) {
            [minuteArray removeObject:[NSString stringWithFormat:@"%ld",(long)lastMinute]];
            lastMinute--;
        }
    }
    
    //重置分钟选中行，防止越界。
    selectedMinuteRow = selectedHourRow > [minuteArray count] - 1 ? [minuteArray count] - 1 : selectedMinuteRow;
}
#pragma mark 重置秒
- (void)resetSecondArrayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour mintues:(NSInteger)minute{
    NSInteger totalSecond = 59;
    if (_maxYear == year && maxMonth == month && maxDay == day && maxHour == hour && maxMinute == minute) {
        totalSecond = maxSecond; //限制秒。
    }
    
    NSInteger lastSecond = [secondArray[secondArray.count - 1] integerValue]; //数组中最大秒数。
    if (lastSecond < totalSecond) {
        while (++lastSecond <= totalSecond) {
            [secondArray addObject:[NSString stringWithFormat:@"%ld",(long)lastSecond]];
        }
    }else if (lastSecond > totalSecond){
        while (lastSecond > totalSecond) {
            [secondArray removeObject:[NSString stringWithFormat:@"%ld",(long)lastSecond]];
            lastSecond--;
        }
    }
    //重置秒选中行，防止越界。
    selectedSecondRow = selectedMinuteRow > [secondArray count] - 1 ? [secondArray count] - 1 : selectedSecondRow;
}


#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArr[component] count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGFloat labelWidth = 0.0;
        labelWidth = CGRectGetWidth(pickerView.frame) / self.dataArr.count;
        pickerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, 30.0f)];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    static BOOL isSelected;
    switch (_datePickerViewShowModel) {
        case CSDatePickerViewShowModelDefalut:
        {
            switch (component) {
                case 0:
                {
                    if (row == selectedYearRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 1:
                {
                    if (row == selectedMonthRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 2:
                {
                    if (row == selectedDayRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 3:
                {
                    if (row == selectedHourRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 4:
                {
                    if (row == selectedMinuteRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelYearMonthDayHour:
        {
            switch (component) {
                case 0:
                {
                    if (row == selectedYearRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 1:
                {
                    if (row == selectedMonthRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 2:
                {
                    if (row == selectedDayRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 3:
                {
                    if (row == selectedHourRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelYearMonthDay:
        {
            switch (component) {
                case 0:
                {
                    if (row == selectedYearRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 1:
                {
                    if (row == selectedMonthRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 2:
                {
                    if (row == selectedDayRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelHourMintueSecond:
        {
            switch (component) {
                case 0:
                {
                    if (row == selectedHourRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 1:
                {
                    if (row == selectedMinuteRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 2:
                {
                    if (row == selectedSecondRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelDefalutSecond:
        {
            switch (component) {
                case 0:
                {
                    if (row == selectedYearRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 1:
                {
                    if (row == selectedMonthRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 2:
                {
                    if (row == selectedDayRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 3:
                {
                    if (row == selectedHourRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 4:
                {
                    if (row == selectedMinuteRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                case 5:
                {
                    if (row == selectedSecondRow) {
                        isSelected = YES;
                    }else{
                        isSelected = NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    if (isSelected) {
        pickerLabel.textColor = [UIColor redColor];
    }else{
        pickerLabel.textColor = [UIColor blackColor];
    }
    pickerLabel.text = [self.dataArr[component] objectAtIndex:row];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (_datePickerViewShowModel) {
        case CSDatePickerViewShowModelDefalut:
        {
            switch (component) {
                case 0:
                {
                    [self selectWithYearRow:row monthRow:nil dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 1:
                {
                    [self selectWithYearRow:nil monthRow:row dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 2:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:row hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 3:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:row mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 4:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:nil mintueRow:row secondRow:nil];
                    [self.datePickerView reloadComponent:4];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelYearMonthDayHour:
        {
            switch (component) {
                case 0:
                {
                    [self selectWithYearRow:row monthRow:nil dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 1:
                {
                    [self selectWithYearRow:nil monthRow:row dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 2:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:row hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 3:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:row mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadComponent:3];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelYearMonthDay:
        {
            switch (component) {
                case 0:
                {
                    [self selectWithYearRow:row monthRow:nil dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 1:
                {
                    [self selectWithYearRow:nil monthRow:row dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 2:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:row hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadComponent:2];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelHourMintueSecond:
        {
            switch (component) {
                case 0:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:row mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 1:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:nil mintueRow:row secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 2:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:nil mintueRow:nil secondRow:row];
                    [self.datePickerView reloadComponent:2];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CSDatePickerViewShowModelDefalutSecond:
        {
            switch (component) {
                case 0:
                {
                    [self selectWithYearRow:row monthRow:nil dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 1:
                {
                    [self selectWithYearRow:nil monthRow:row dayRow:nil hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 2:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:row hourRow:nil mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 3:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:row mintueRow:nil secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 4:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:nil mintueRow:row secondRow:nil];
                    [self.datePickerView reloadAllComponents];
                }
                    break;
                case 5:
                {
                    [self selectWithYearRow:nil monthRow:nil dayRow:nil hourRow:nil mintueRow:nil secondRow:row];
                    [self.datePickerView reloadComponent:5];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)selectWithYearRow:(NSInteger)rowYear monthRow:(NSInteger)rowMon dayRow:(NSInteger)rowDay hourRow:(NSInteger)rowHour mintueRow:(NSInteger)rowMintue secondRow:(NSInteger)rowSecond{
    static NSInteger selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute;
    if (rowYear) {
        selectedYearRow = rowYear;
    }
    selectedYear = [[yearArray objectAtIndex:selectedYearRow] integerValue]; //获取选择的年份。
    if (rowYear) {
        [self resetMonthArrayWithYear:selectedYear]; //重置月份。
    }
    
    if (rowMon) {
        selectedMonthRow = rowMon;
    }
    selectedMonth = [[monthArray objectAtIndex:selectedMonthRow] integerValue]; //获取选择的月份。
    if (rowMon||rowYear) {
        [self resetDayArrayWithYear:selectedYear month:selectedMonth]; //重置天数。
    }
    if (rowDay) {
        selectedDayRow = rowDay;
    }
    selectedDay = [[dayArray objectAtIndex:selectedDayRow] integerValue]; //获取选择的天数。
    if (rowDay||rowMon||rowYear) {
        [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
    }
    
    if (rowHour) {
        selectedHourRow = rowHour;
    }
    selectedHour = [[hourArray objectAtIndex:selectedHourRow] integerValue]; //获取选择的小时。
    if (rowHour||rowDay||rowMon||rowYear) {
        [self resetMinuteArrayWithYear:selectedYear month:selectedMonth day:selectedDay hour:selectedHour]; //重置分钟。
    }
    
    if (rowMintue) {
        selectedMinuteRow = rowMintue;
    }
    selectedMinute = [[minuteArray objectAtIndex:selectedMinuteRow] integerValue];//获取选择的分钟。
    if (rowMintue||rowHour||rowDay||rowMon||rowYear) {
        [self resetSecondArrayWithYear:selectedYear month:selectedMonth day:selectedDay hour:selectedHour mintues:selectedMinute];//重制秒
    }
    
    if (rowSecond) {
        selectedSecondRow = rowSecond;
    }
    
}



//确定按钮
- (void)confirmButtonClicked{
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    switch (_datePickerViewShowModel) {
        case CSDatePickerViewShowModelDefalut:
        {
            [dateComponents setYear:[[yearArray objectAtIndex:[self.datePickerView selectedRowInComponent:0]] integerValue]];
            [dateComponents setMonth:[[monthArray objectAtIndex:[self.datePickerView selectedRowInComponent:1]] integerValue]];
            [dateComponents setDay:[[dayArray objectAtIndex:[self.datePickerView selectedRowInComponent:2]] integerValue]];
            [dateComponents setHour:[[hourArray objectAtIndex:[self.datePickerView selectedRowInComponent:3]] integerValue]];
            [dateComponents setMinute:[[minuteArray objectAtIndex:[self.datePickerView selectedRowInComponent:4]] integerValue]];
            [dateComponents setSecond:selectedSecondRow];
        }
            break;
        case CSDatePickerViewShowModelYearMonthDay:
        {
            [dateComponents setYear:[[yearArray objectAtIndex:[self.datePickerView selectedRowInComponent:0]] integerValue]];
            [dateComponents setMonth:[[monthArray objectAtIndex:[self.datePickerView selectedRowInComponent:1]] integerValue]];
            [dateComponents setDay:[[dayArray objectAtIndex:[self.datePickerView selectedRowInComponent:2]] integerValue]];
            [dateComponents setHour:selectedHourRow];
            [dateComponents setMinute:selectedMinuteRow];
            [dateComponents setSecond:selectedSecondRow];
        }
            break;
        case CSDatePickerViewShowModelYearMonthDayHour:
        {
            [dateComponents setYear:[[yearArray objectAtIndex:[self.datePickerView selectedRowInComponent:0]] integerValue]];
            [dateComponents setMonth:[[monthArray objectAtIndex:[self.datePickerView selectedRowInComponent:1]] integerValue]];
            [dateComponents setDay:[[dayArray objectAtIndex:[self.datePickerView selectedRowInComponent:2]] integerValue]];
            [dateComponents setHour:[[hourArray objectAtIndex:[self.datePickerView selectedRowInComponent:3]] integerValue]];
            [dateComponents setMinute:selectedMinuteRow];
            [dateComponents setSecond:selectedSecondRow];
        }
            break;
        case CSDatePickerViewShowModelHourMintueSecond:
        {
            [dateComponents setYear:selectedYearRow];
            [dateComponents setMonth:selectedMonthRow];
            [dateComponents setDay:selectedDayRow];
            [dateComponents setHour:[[hourArray objectAtIndex:[self.datePickerView selectedRowInComponent:0]] integerValue]];
            [dateComponents setMinute:[[minuteArray objectAtIndex:[self.datePickerView selectedRowInComponent:1]] integerValue]];
            [dateComponents setSecond:[[secondArray objectAtIndex:[self.datePickerView selectedRowInComponent:2]] integerValue]];
        }
            break;
        case CSDatePickerViewShowModelDefalutSecond:
        {
            [dateComponents setYear:[[yearArray objectAtIndex:[self.datePickerView selectedRowInComponent:0]] integerValue]];
            [dateComponents setMonth:[[monthArray objectAtIndex:[self.datePickerView selectedRowInComponent:1]] integerValue]];
            [dateComponents setDay:[[dayArray objectAtIndex:[self.datePickerView selectedRowInComponent:2]] integerValue]];
            [dateComponents setHour:[[hourArray objectAtIndex:[self.datePickerView selectedRowInComponent:3]] integerValue]];
            [dateComponents setMinute:[[minuteArray objectAtIndex:[self.datePickerView selectedRowInComponent:4]] integerValue]];
            [dateComponents setSecond:[[secondArray objectAtIndex:[self.datePickerView selectedRowInComponent:5]] integerValue]];
        }
            break;
    }
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        [self.delegate datePickerView:self.datePickerView didSelectDate:selectedDate];
    }
    [self close];
}

//取消按钮
- (void)cancelButtonClicked{
    [self close];
}

- (void)show{
    [self showDataPickerView:YES withAnimation:AnimationDuration];
    [self choseNowTime];
}
- (void)close{
    [self showDataPickerView:NO withAnimation:AnimationDuration];
}
- (void)showDataPickerView:(BOOL)isShow withAnimation:(NSTimeInterval)duration{
    @synchronized(self){
        if(isShow){
            [UIView animateWithDuration:duration animations:^{
                //高度减去状态栏以及导航栏的高度44
                [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-44,self.frame.size.width,self.frame.size.height)];
            }];
        }else {
            [UIView animateWithDuration:duration animations:^{
                [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,self.frame.size.width,self.frame.size.height)];
            }completion:^(BOOL finished){
            }];
        }
    };
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
