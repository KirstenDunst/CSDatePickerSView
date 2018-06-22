//
//  FBFiltrateView.h
//  FSFuBei
//
//  Created by 曹世鑫 on 2018/6/11.
//  Copyright © 2018年 曹世鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
//，，开始和结束的时间（字符串），后期需要在修改

/**
 筛选返回的条件类型

 @param payType 这里暂时定义为返回的支付类型（字符串）,如果为单纯的时间筛选，这里支付类型返回的是nil。
 @param begainTime 开始的时间（NSDate类型）
 @param endTime 结束的时间（NSDate类型）
 */
typedef void(^SelectedBack)(NSString *payType, NSDate *begainTime,NSDate *endTime);

@interface FBFiltrateView : UIView
//不同界面对应的不同显示内容。后期标注不同值对应的界面跳转，方便后期维护修改
//目前，1表示支付类型+加时间筛选
//     0表示单纯的时间筛选
@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)SelectedBack selectedBack;
@end
