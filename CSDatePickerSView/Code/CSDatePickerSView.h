//
//  CSDatePickerSView.h
//  CSDatePickerSView
//
//  Created by 曹世鑫 on 2018/6/20.
//  Copyright © 2018年 曹世鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  日期选择器显示模式。
 */
typedef NS_ENUM(NSInteger, CSDatePickerViewShowModel) {
    //显示年，月，日，时，分。
    CSDatePickerViewShowModelDefalut,
    //显示年，月，日，时。
    CSDatePickerViewShowModelYearMonthDayHour,
    //显示年，月，日。
    CSDatePickerViewShowModelYearMonthDay,
    //显示时，分，秒。
    CSDatePickerViewShowModelHourMintueSecond,
    //显示年，月，日，时，分，秒。
    CSDatePickerViewShowModelDefalutSecond,
};

/**
 *  日期选择器时间范围。
 */
typedef NS_ENUM(NSInteger, CSDatePickerViewDateRangeModel) {
    //最大时间为当前系统时间。用途：例如选择生日的时候不可能大于当前时间。
    CSDatePickerViewDateRangeModelCurrent,
    //自定义时间范围。可通过下面的属性minYear和maxYear设定。
    CSDatePickerViewDateRangeModelCustom,
};

@protocol CSDatePickerSViewDelegate <NSObject>   //声明一个代理

/**
 时间选择器的返回（eg：如果我们选择的CSDatePickerViewShowModel是只有年月日的CSDatePickerViewShowModelYearMonthDay，那么我们返回的date只有年月日时我们选的，至于转换成字符串之后的时分秒是我们创建这个控件的时候的值，换句话说既然你选择显示的是年月日，那么时分秒你就不用取）
 
 @param datePickerView 时间选择器的对象
 @param date 返回的日期值，NSDate类型。
 */
- (void)datePickerView:(UIPickerView *)datePickerView didSelectDate:(NSDate *)date;

@end


@interface CSDatePickerSView : UIView

//显示
- (void)show;
//关闭
- (void)close;
//刷新处理(如果配合切换日期显示模式，建议先刷新然后再设置日期显示模式切换)
- (void)reloadDataNew;

//日期显示模式，默认为CSDatePickerViewShowModelDefalut。
@property (nonatomic, assign) CSDatePickerViewShowModel datePickerViewShowModel;

//时间范围模式，默认为CSDatePickerViewDateRangeModelCurrent。
@property (nonatomic, assign) CSDatePickerViewDateRangeModel  datePickerViewDateRangeModel;

//时间列表最小年份，不能大于最大年份。默认为1970年。
@property (nonatomic, assign) NSInteger minYear;
//时间列表最大年份，不能小于最小年份。默认为当前年份。注意：仅当属性datePickerViewDateRangeModel的值为CSDatePickerViewDateRangeModelCustom时才有效。
@property (nonatomic, assign) NSInteger maxYear;

@property(strong,nonatomic) id<CSDatePickerSViewDelegate> delegate;
@end
